class TargetStatusBuff1Wnd extends UICommonAPI;

var WindowHandle Me;
var StatusIconHandle StatusIcons;

function OnRegisterEvent()
{
    return;
}

function OnLoad()
{
    // End:0x0D
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x1D
    if(1 == 0)
    {
        Initialize();        
    }
    else
    {
        InitializeCOD();
    }
    load();
    return;
}

function Initialize()
{
    Me = GetHandle("TargetStatusBuff1Wnd");
    StatusIcons = StatusIconHandle(GetHandle("TargetStatusBuff1Wnd.StatusIcons"));
    return;
}

function InitializeCOD()
{
    Me = GetWindowHandle("TargetStatusBuff1Wnd");
    StatusIcons = GetStatusIconHandle("TargetStatusBuff1Wnd.StatusIcons");
    return;
}

function load()
{
    return;
}

function showBuff(array<StatusIconInfo> Info)
{
    local int i, j, LINE, Length, remainder, LineCount;

    Info = arrayReverse(Info);
    LineCount = 0;
    Length = Info.Length;
    LINE = ((Length - 1) / 6) + 1;
    remainder = int(float(Length) % float(6));
    ResetBuffIcon();
    reSizeWindow(Length);
    // End:0xB8
    if(LINE < 2)
    {
        StatusIcons.AddRow();
        i = 0;
        J0x81:

        // End:0xB5 [Loop If]
        if(i < Length)
        {
            StatusIcons.AddCol(0, Info[i]);
            i++;
            // [Loop Continue]
            goto J0x81;
        }        
    }
    else
    {
        // End:0xCB
        if(remainder == 0)
        {
            remainder = 6;
        }
        j = LINE - 1;
        J0xD9:

        // End:0x160 [Loop If]
        if(j >= 1)
        {
            StatusIcons.AddRow();
            i = remainder + ((j - 1) * 6);
            J0x10C:

            // End:0x14F [Loop If]
            if(i < (remainder + (j * 6)))
            {
                StatusIcons.AddCol(LineCount, Info[i]);
                i++;
                // [Loop Continue]
                goto J0x10C;
            }
            LineCount++;
            j--;
            // [Loop Continue]
            goto J0xD9;
        }
        StatusIcons.AddRow();
        i = 0;
        J0x176:

        // End:0x1AE [Loop If]
        if(i < remainder)
        {
            StatusIcons.AddCol(LineCount, Info[i]);
            i++;
            // [Loop Continue]
            goto J0x176;
        }
        LineCount++;
    }
    return;
}

function reSizeWindow(int Count)
{
    local int W, h;

    // End:0x17
    if(Count > 5)
    {
        W = 168;        
    }
    else
    {
        W = (26 * Count) + 12;
    }
    h = (26 * (((Count - 1) / 6) + 1)) + 12;
    Me.SetWindowSize(W, h);
    return;
}

function array<StatusIconInfo> arrayReverse(array<StatusIconInfo> Info)
{
    local int i;
    local array<StatusIconInfo> infoRe;

    i = Info.Length - 1;
    J0x0F:

    // End:0x4C [Loop If]
    if(i >= 0)
    {
        infoRe.Insert(infoRe.Length, 1);
        infoRe[infoRe.Length - 1] = Info[i];
        i--;
        // [Loop Continue]
        goto J0x0F;
    }
    return infoRe;
    return;
}

function ResetBuffIcon()
{
    StatusIcons.Clear();
    return;
}
