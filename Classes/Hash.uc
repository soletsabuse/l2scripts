class Hash extends UICommonAPI;

const hex = "0123456789abcdef";

var private Guid StaticHashValue;
var array<byte> StaticData;

static final function Guid GetStringHash(string in)
{
    local int StrLen, i;

    StrLen = Len(in);
    default.StaticData.Length = StrLen;
    i = 0;
    J0x20:

    // End:0x56 [Loop If]
    if(i < StrLen)
    {
        default.StaticData[i] = byte(Asc(Mid(in, i, 1)));
        i++;
        // [Loop Continue]
        goto J0x20;
    }
    StaticProcessChunks();
    return default.StaticHashValue;
    return;
}

static final function string getHash(string in)
{
    local int StrLen, i;

    StrLen = Len(in);
    default.StaticData.Length = StrLen;
    i = 0;
    J0x20:

    // End:0x56 [Loop If]
    if(i < StrLen)
    {
        default.StaticData[i] = byte(Asc(Mid(in, i, 1)));
        i++;
        // [Loop Continue]
        goto J0x20;
    }
    StaticProcessChunks();
    return ((LittleEndianToHex(default.StaticHashValue.A) $ LittleEndianToHex(default.StaticHashValue.B)) $ LittleEndianToHex(default.StaticHashValue.C)) $ LittleEndianToHex(default.StaticHashValue.D);
    return;
}

static final function string GetStringHashString(string in)
{
    local int StrLen, i;

    StrLen = Len(in);
    default.StaticData.Length = StrLen;
    i = 0;
    J0x20:

    // End:0x56 [Loop If]
    if(i < StrLen)
    {
        default.StaticData[i] = byte(Asc(Mid(in, i, 1)));
        i++;
        // [Loop Continue]
        goto J0x20;
    }
    StaticProcessChunks();
    return ((LittleEndianToHex(default.StaticHashValue.A) $ LittleEndianToHex(default.StaticHashValue.B)) $ LittleEndianToHex(default.StaticHashValue.C)) $ LittleEndianToHex(default.StaticHashValue.D);
    return;
}

static final function Guid GetArrayHash(array<byte> in)
{
    default.StaticData = in;
    StaticProcessChunks();
    return default.StaticHashValue;
    return;
}

static final function string GetArrayHashString(array<byte> in)
{
    default.StaticData = in;
    StaticProcessChunks();
    return ((LittleEndianToHex(default.StaticHashValue.A) $ LittleEndianToHex(default.StaticHashValue.B)) $ LittleEndianToHex(default.StaticHashValue.C)) $ LittleEndianToHex(default.StaticHashValue.D);
    return;
}

static final function string GetHashString(Guid Hash)
{
    return ((LittleEndianToHex(Hash.A) $ LittleEndianToHex(Hash.B)) $ LittleEndianToHex(Hash.C)) $ LittleEndianToHex(Hash.D);
    return;
}

static final function string LittleEndianToHex(int i)
{
    return ((((((Mid("0123456789abcdef", (i >> 4) & 15, 1) $ Mid("0123456789abcdef", i & 15, 1)) $ Mid("0123456789abcdef", (i >> 12) & 15, 1)) $ Mid("0123456789abcdef", (i >> 8) & 15, 1)) $ Mid("0123456789abcdef", (i >> 20) & 15, 1)) $ Mid("0123456789abcdef", (i >> 16) & 15, 1)) $ Mid("0123456789abcdef", (i >> 28) & 15, 1)) $ Mid("0123456789abcdef", (i >> 24) & 15, 1);
    return;
}

static final function StaticProcessChunks()
{
    local int i, A, B, C, D, W[16];

    i = default.StaticData.Length;
    // End:0x49
    if((float(i) % float(64)) < float(56))
    {
        default.StaticData.Length = int(float(default.StaticData.Length + 64) - (float(i) % float(64)));        
    }
    else
    {
        default.StaticData.Length = int(float(default.StaticData.Length + 128) - (float(i) % float(64)));
    }
    default.StaticData[i] = 128;
    default.StaticData[default.StaticData.Length - 4] = byte(i >>> 29);
    default.StaticData[default.StaticData.Length - 5] = byte(i >>> 21);
    default.StaticData[default.StaticData.Length - 6] = byte(i >>> 13);
    default.StaticData[default.StaticData.Length - 7] = byte(i >>> 5);
    default.StaticData[default.StaticData.Length - 8] = byte(i << 3);
    default.StaticHashValue.A = 1732584449;
    default.StaticHashValue.B = -271733623;
    default.StaticHashValue.C = -1732583938;
    default.StaticHashValue.D = 271734134;
    J0x147:

    // End:0x1725 [Loop If]
    if(default.StaticData.Length > 0)
    {
        i = 0;
        J0x15A:

        // End:0x1DD [Loop If]
        if(i < 16)
        {
            W[i] = (((int(default.StaticData[(i * 4) + 3]) << 24) | (int(default.StaticData[(i * 4) + 2]) << 16)) | (int(default.StaticData[(i * 4) + 1]) << 8)) | int(default.StaticData[i * 4]);
            i++;
            // [Loop Continue]
            goto J0x15A;
        }
        A = default.StaticHashValue.A;
        B = default.StaticHashValue.B;
        C = default.StaticHashValue.C;
        D = default.StaticHashValue.D;
        A += (((D ^ (B & (C ^ D))) + W[0]) + -680876936);
        A = B + ((A << 7) | (A >>> -7));
        D += (((C ^ (A & (B ^ C))) + W[1]) + -389564586);
        D = A + ((D << 12) | (D >>> -12));
        C += (((B ^ (D & (A ^ B))) + W[2]) + 606105819);
        C = D + ((C << 17) | (C >>> -17));
        B += (((A ^ (C & (D ^ A))) + W[3]) + -1044525330);
        B = C + ((B << 22) | (B >>> -22));
        A += (((D ^ (B & (C ^ D))) + W[4]) + -176418897);
        A = B + ((A << 7) | (A >>> -7));
        D += (((C ^ (A & (B ^ C))) + W[5]) + 1200080426);
        D = A + ((D << 12) | (D >>> -12));
        C += (((B ^ (D & (A ^ B))) + W[6]) + -1473231341);
        C = D + ((C << 17) | (C >>> -17));
        B += (((A ^ (C & (D ^ A))) + W[7]) + -45705983);
        B = C + ((B << 22) | (B >>> -22));
        A += (((D ^ (B & (C ^ D))) + W[8]) + 1770035416);
        A = B + ((A << 7) | (A >>> -7));
        D += (((C ^ (A & (B ^ C))) + W[9]) + -1958414417);
        D = A + ((D << 12) | (D >>> -12));
        C += (((B ^ (D & (A ^ B))) + W[10]) + -42063);
        C = D + ((C << 17) | (C >>> -17));
        B += (((A ^ (C & (D ^ A))) + W[11]) + -1990404162);
        B = C + ((B << 22) | (B >>> -22));
        A += (((D ^ (B & (C ^ D))) + W[12]) + 1804603682);
        A = B + ((A << 7) | (A >>> -7));
        D += (((C ^ (A & (B ^ C))) + W[13]) + -40341101);
        D = A + ((D << 12) | (D >>> -12));
        C += (((B ^ (D & (A ^ B))) + W[14]) + -1502002290);
        C = D + ((C << 17) | (C >>> -17));
        B += (((A ^ (C & (D ^ A))) + W[15]) + 1236535329);
        B = C + ((B << 22) | (B >>> -22));
        A += (((C ^ (D & (B ^ C))) + W[1]) + -165796510);
        A = B + ((A << 5) | (A >>> -5));
        D += (((B ^ (C & (A ^ B))) + W[6]) + -1069501632);
        D = A + ((D << 9) | (D >>> -9));
        C += (((A ^ (B & (D ^ A))) + W[11]) + 643717713);
        C = D + ((C << 14) | (C >>> -14));
        B += (((D ^ (A & (C ^ D))) + W[0]) + -373897302);
        B = C + ((B << 20) | (B >>> -20));
        A += (((C ^ (D & (B ^ C))) + W[5]) + -701558691);
        A = B + ((A << 5) | (A >>> -5));
        D += (((B ^ (C & (A ^ B))) + W[10]) + 38016083);
        D = A + ((D << 9) | (D >>> -9));
        C += (((A ^ (B & (D ^ A))) + W[15]) + -660478335);
        C = D + ((C << 14) | (C >>> -14));
        B += (((D ^ (A & (C ^ D))) + W[4]) + -405537848);
        B = C + ((B << 20) | (B >>> -20));
        A += (((C ^ (D & (B ^ C))) + W[9]) + 568446438);
        A = B + ((A << 5) | (A >>> -5));
        D += (((B ^ (C & (A ^ B))) + W[14]) + -1019803690);
        D = A + ((D << 9) | (D >>> -9));
        C += (((A ^ (B & (D ^ A))) + W[3]) + -187363961);
        C = D + ((C << 14) | (C >>> -14));
        B += (((D ^ (A & (C ^ D))) + W[8]) + 1163531501);
        B = C + ((B << 20) | (B >>> -20));
        A += (((C ^ (D & (B ^ C))) + W[13]) + -1444681467);
        A = B + ((A << 5) | (A >>> -5));
        D += (((B ^ (C & (A ^ B))) + W[2]) + -51403784);
        D = A + ((D << 9) | (D >>> -9));
        C += (((A ^ (B & (D ^ A))) + W[7]) + 1735328473);
        C = D + ((C << 14) | (C >>> -14));
        B += (((D ^ (A & (C ^ D))) + W[12]) + -1926607734);
        B = C + ((B << 20) | (B >>> -20));
        A += ((((B ^ C) ^ D) + W[5]) + -378558);
        A = B + ((A << 4) | (A >>> -4));
        D += ((((A ^ B) ^ C) + W[8]) + -2022574463);
        D = A + ((D << 11) | (D >>> -11));
        C += ((((D ^ A) ^ B) + W[11]) + 1839030562);
        C = D + ((C << 16) | (C >>> -16));
        B += ((((C ^ D) ^ A) + W[14]) + -35309556);
        B = C + ((B << 23) | (B >>> -23));
        A += ((((B ^ C) ^ D) + W[1]) + -1530992060);
        A = B + ((A << 4) | (A >>> -4));
        D += ((((A ^ B) ^ C) + W[4]) + 1272893353);
        D = A + ((D << 11) | (D >>> -11));
        C += ((((D ^ A) ^ B) + W[7]) + -155497632);
        C = D + ((C << 16) | (C >>> -16));
        B += ((((C ^ D) ^ A) + W[10]) + -1094730640);
        B = C + ((B << 23) | (B >>> -23));
        A += ((((B ^ C) ^ D) + W[13]) + 681279174);
        A = B + ((A << 4) | (A >>> -4));
        D += ((((A ^ B) ^ C) + W[0]) + -358537222);
        D = A + ((D << 11) | (D >>> -11));
        C += ((((D ^ A) ^ B) + W[3]) + -722521979);
        C = D + ((C << 16) | (C >>> -16));
        B += ((((C ^ D) ^ A) + W[6]) + 76029189);
        B = C + ((B << 23) | (B >>> -23));
        A += ((((B ^ C) ^ D) + W[9]) + -640364487);
        A = B + ((A << 4) | (A >>> -4));
        D += ((((A ^ B) ^ C) + W[12]) + -421815835);
        D = A + ((D << 11) | (D >>> -11));
        C += ((((D ^ A) ^ B) + W[15]) + 530742520);
        C = D + ((C << 16) | (C >>> -16));
        B += ((((C ^ D) ^ A) + W[2]) + -995338651);
        B = C + ((B << 23) | (B >>> -23));
        A += (((C ^ (B | ~D)) + W[0]) + -198630844);
        A = B + ((A << 6) | (A >>> -6));
        D += (((B ^ (A | ~C)) + W[7]) + 1126891415);
        D = A + ((D << 10) | (D >>> -10));
        C += (((A ^ (D | ~B)) + W[14]) + -1416354905);
        C = D + ((C << 15) | (C >>> -15));
        B += (((D ^ (C | ~A)) + W[5]) + -57434055);
        B = C + ((B << 21) | (B >>> -21));
        A += (((C ^ (B | ~D)) + W[12]) + 1700485571);
        A = B + ((A << 6) | (A >>> -6));
        D += (((B ^ (A | ~C)) + W[3]) + -1894986606);
        D = A + ((D << 10) | (D >>> -10));
        C += (((A ^ (D | ~B)) + W[10]) + -1051523);
        C = D + ((C << 15) | (C >>> -15));
        B += (((D ^ (C | ~A)) + W[1]) + -2054922799);
        B = C + ((B << 21) | (B >>> -21));
        A += (((C ^ (B | ~D)) + W[8]) + 1873313359);
        A = B + ((A << 6) | (A >>> -6));
        D += (((B ^ (A | ~C)) + W[15]) + -30611744);
        D = A + ((D << 10) | (D >>> -10));
        C += (((A ^ (D | ~B)) + W[6]) + -1560198380);
        C = D + ((C << 15) | (C >>> -15));
        B += (((D ^ (C | ~A)) + W[13]) + 1309151649);
        B = C + ((B << 21) | (B >>> -21));
        A += (((C ^ (B | ~D)) + W[4]) + -145523070);
        A = B + ((A << 6) | (A >>> -6));
        D += (((B ^ (A | ~C)) + W[11]) + -1120210379);
        D = A + ((D << 10) | (D >>> -10));
        C += (((A ^ (D | ~B)) + W[2]) + 718787259);
        C = D + ((C << 15) | (C >>> -15));
        B += (((D ^ (C | ~A)) + W[9]) + -343485551);
        B = C + ((B << 21) | (B >>> -21));
        default.StaticHashValue.A += A;
        default.StaticHashValue.B += B;
        default.StaticHashValue.C += C;
        default.StaticData.Remove(0, 64);
        default.StaticHashValue.D += D;
        // [Loop Continue]
        goto J0x147;
    }
    return;
}
