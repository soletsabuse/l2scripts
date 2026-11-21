using System;
using System.Collections.Generic;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;

namespace EnchPanel
{
    /// <summary>The microphone (winmm waveIn, no extra library): 16 kHz mono 16-bit, open the whole time the voice is on.
    /// The last PreMs are kept, so a word started together with the key press is not cut. Begin() .. End(): one take.</summary>
    sealed class MicRecorder : IDisposable
    {
        public const int Rate = 16000;
        const int BufMs = 40, Bufs = 10, PreMs = 300;

        [StructLayout(LayoutKind.Sequential)]
        struct WAVEFORMATEX { public ushort wFormatTag, nChannels; public uint nSamplesPerSec, nAvgBytesPerSec; public ushort nBlockAlign, wBitsPerSample, cbSize; }
        [StructLayout(LayoutKind.Sequential)]
        struct WAVEHDR { public IntPtr lpData; public uint dwBufferLength, dwBytesRecorded; public IntPtr dwUser; public uint dwFlags, dwLoops; public IntPtr lpNext, reserved; }
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
        struct WAVEINCAPS { public ushort wMid, wPid; public uint vDriverVersion; [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)] public string szPname; public uint dwFormats; public ushort wChannels, wReserved1; }

        [DllImport("winmm.dll")] static extern int waveInGetNumDevs();
        [DllImport("winmm.dll", CharSet = CharSet.Unicode)] static extern int waveInGetDevCapsW(IntPtr uDeviceID, out WAVEINCAPS caps, int size);
        [DllImport("winmm.dll")] static extern int waveInOpen(out IntPtr h, IntPtr dev, ref WAVEFORMATEX fmt, IntPtr cb, IntPtr inst, int flags);
        [DllImport("winmm.dll")] static extern int waveInPrepareHeader(IntPtr h, IntPtr hdr, int size);
        [DllImport("winmm.dll")] static extern int waveInUnprepareHeader(IntPtr h, IntPtr hdr, int size);
        [DllImport("winmm.dll")] static extern int waveInAddBuffer(IntPtr h, IntPtr hdr, int size);
        [DllImport("winmm.dll")] static extern int waveInStart(IntPtr h);
        [DllImport("winmm.dll")] static extern int waveInReset(IntPtr h);
        [DllImport("winmm.dll")] static extern int waveInClose(IntPtr h);
        const uint WHDR_DONE = 1;

        IntPtr _h;
        readonly IntPtr[] _hdr = new IntPtr[Bufs], _data = new IntPtr[Bufs];
        Thread? _thr;
        volatile bool _run;
        readonly object _lock = new object();
        MemoryStream? _take;
        readonly Queue<byte[]> _pre = new Queue<byte[]>();
        int _preBytes;
        public string Error { get; private set; } = "";
        /// <summary>The loudest sample of the last ~0.5 s, 0..1 (the page shows it: is the mic alive).</summary>
        public float Level { get; private set; }
        float _peak;
        int _peakN;

        /// <summary>The input devices; index = the waveIn device number (-1: the Windows default).</summary>
        public static List<string> Devices()
        {
            var list = new List<string>();
            int n = waveInGetNumDevs();
            for (int i = 0; i < n; i++)
                list.Add(waveInGetDevCapsW(new IntPtr(i), out var caps, Marshal.SizeOf<WAVEINCAPS>()) == 0 ? caps.szPname : "device " + i);
            return list;
        }

        public bool IsOpen => _h != IntPtr.Zero;

        public bool Open(int device)
        {
            Close();
            var fmt = new WAVEFORMATEX { wFormatTag = 1, nChannels = 1, nSamplesPerSec = Rate, wBitsPerSample = 16, nBlockAlign = 2, nAvgBytesPerSec = Rate * 2, cbSize = 0 };
            int r = waveInOpen(out _h, new IntPtr(device), ref fmt, IntPtr.Zero, IntPtr.Zero, 0);   // CALLBACK_NULL: the thread looks at the buffers
            if (r != 0)
            {
                _h = IntPtr.Zero;
                Error = "the microphone did not open (waveIn " + r + ")";
                return false;
            }
            int bytes = Rate * 2 * BufMs / 1000, hs = Marshal.SizeOf<WAVEHDR>();
            for (int i = 0; i < Bufs; i++)
            {
                _data[i] = Marshal.AllocHGlobal(bytes);
                _hdr[i] = Marshal.AllocHGlobal(hs);
                Marshal.StructureToPtr(new WAVEHDR { lpData = _data[i], dwBufferLength = (uint)bytes }, _hdr[i], false);
                waveInPrepareHeader(_h, _hdr[i], hs);
                waveInAddBuffer(_h, _hdr[i], hs);
            }
            waveInStart(_h);
            Error = "";
            _run = true;
            _thr = new Thread(Loop) { IsBackground = true, Name = "voice mic" };
            _thr.Start();
            return true;
        }

        void Loop()
        {
            int hs = Marshal.SizeOf<WAVEHDR>();
            int offFlags = (int)Marshal.OffsetOf<WAVEHDR>("dwFlags"), offRec = (int)Marshal.OffsetOf<WAVEHDR>("dwBytesRecorded");
            int i = 0;
            while (_run)
            {
                uint flags = (uint)Marshal.ReadInt32(_hdr[i], offFlags);
                if ((flags & WHDR_DONE) == 0)
                {
                    Thread.Sleep(5);
                    continue;
                }
                int n = Marshal.ReadInt32(_hdr[i], offRec);
                if (n > 0)
                {
                    var b = new byte[n];
                    Marshal.Copy(_data[i], b, 0, n);
                    Took(b);
                }
                if (!_run) break;
                Marshal.WriteInt32(_hdr[i], offFlags, (int)(flags & ~WHDR_DONE));
                waveInAddBuffer(_h, _hdr[i], hs);
                i = (i + 1) % Bufs;
            }
        }

        void Took(byte[] b)
        {
            for (int k = 0; k + 1 < b.Length; k += 2)
            {
                float v = Math.Abs((short)(b[k] | (b[k + 1] << 8))) / 32768f;
                if (v > _peak) _peak = v;
            }
            if (++_peakN * BufMs >= 500)
            {
                Level = _peak;
                _peak = 0;
                _peakN = 0;
            }
            lock (_lock)
            {
                if (_take != null)
                {
                    _take.Write(b, 0, b.Length);
                    return;
                }
                _pre.Enqueue(b);
                _preBytes += b.Length;
                while (_preBytes > Rate * 2 * PreMs / 1000 && _pre.Count > 1) _preBytes -= _pre.Dequeue().Length;
            }
        }

        /// <summary>A take starts (with the last PreMs before it).</summary>
        public void Begin()
        {
            lock (_lock)
            {
                _take = new MemoryStream();
                foreach (var b in _pre) _take.Write(b, 0, b.Length);
                _pre.Clear();
                _preBytes = 0;
            }
        }

        /// <summary>The take so far (PCM 16 kHz mono 16-bit), ended; null: none going.</summary>
        public byte[]? End()
        {
            Thread.Sleep(BufMs + 10);           // the buffer being filled now: in it too (the last syllable)
            lock (_lock)
            {
                var t = _take;
                _take = null;
                return t?.ToArray();
            }
        }

        public void Close()
        {
            if (_h == IntPtr.Zero) return;
            _run = false;
            _thr?.Join(500);
            waveInReset(_h);
            int hs = Marshal.SizeOf<WAVEHDR>();
            for (int i = 0; i < Bufs; i++)
            {
                if (_hdr[i] != IntPtr.Zero)
                {
                    waveInUnprepareHeader(_h, _hdr[i], hs);
                    Marshal.FreeHGlobal(_hdr[i]);
                    _hdr[i] = IntPtr.Zero;
                }
                if (_data[i] != IntPtr.Zero)
                {
                    Marshal.FreeHGlobal(_data[i]);
                    _data[i] = IntPtr.Zero;
                }
            }
            waveInClose(_h);
            _h = IntPtr.Zero;
        }

        public void Dispose() => Close();

        /// <summary>PCM 16 kHz mono 16-bit as a .wav file.</summary>
        public static byte[] Wav(byte[] pcm, int rate = Rate)
        {
            var ms = new MemoryStream(44 + pcm.Length);
            var w = new BinaryWriter(ms);
            w.Write(Encoding.ASCII.GetBytes("RIFF"));
            w.Write(36 + pcm.Length);
            w.Write(Encoding.ASCII.GetBytes("WAVEfmt "));
            w.Write(16);
            w.Write((short)1);
            w.Write((short)1);
            w.Write(rate);
            w.Write(rate * 2);
            w.Write((short)2);
            w.Write((short)16);
            w.Write(Encoding.ASCII.GetBytes("data"));
            w.Write(pcm.Length);
            w.Write(pcm);
            w.Flush();
            return ms.ToArray();
        }
    }

    /// <summary>Short tones made here (no sound files): the key down, a command done, not understood.</summary>
    static class Beeps
    {
        static byte[]? _start, _ok, _fail;

        static byte[] Tones(params (double Hz, int Ms)[] parts)
        {
            const int rate = 22050;
            var pcm = new MemoryStream();
            foreach (var (hz, msLen) in parts)
            {
                int n = rate * msLen / 1000;
                for (int i = 0; i < n; i++)
                {
                    double env = Math.Min(1.0, Math.Min(i, n - i) / (rate * 0.006));   // no clicks at the edges
                    short v = hz <= 0 ? (short)0 : (short)(Math.Sin(2 * Math.PI * hz * i / rate) * 9000 * env);
                    pcm.WriteByte((byte)(v & 0xFF));
                    pcm.WriteByte((byte)((v >> 8) & 0xFF));
                }
            }
            return MicRecorder.Wav(pcm.ToArray(), rate);
        }

        static void Play(byte[] wav)
        {
            try
            {
                var p = new System.Media.SoundPlayer(new MemoryStream(wav));
                p.Play();
            }
            catch (Exception) { }
        }

        public static void Start() => Play(_start ??= Tones((880, 55)));
        public static void Ok() => Play(_ok ??= Tones((660, 60), (0, 25), (990, 80)));
        public static void Fail() => Play(_fail ??= Tones((300, 90), (0, 30), (220, 140)));
    }
}
