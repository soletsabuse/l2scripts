class AttendCheckAPI extends PacketsInfo;

const PREMIUM_SLOT_OFFSET = 1000;
const SLOT_MAX = 7;
const RS_WAIT_CLICK_DELAY_TIMER = 5870;
const PREMIUM_SLOT_TIMER_INDEX = 1000000;
const PREMIUM_SLOT_SHOW_DELAY = 700;

enum AttendanceRewardState
{
    RS_NONE,                        // 0
    RS_AVAILABLE,                   // 1
    RS_WAIT,                        // 2
    RS_TAKEN,                       // 3
    RS_FUTURE                       // 4
};

struct _slotItem
{
    var WindowHandle SlotWnd;
    var TextureHandle SlotDisableWnd;
    var AnimTextureHandle SlotBringTx;
    var ItemWindowHandle SlotItem;
    var TextBoxHandle Day;
    var TextBoxHandle SlotCount;
};

struct _attendanceItem
{
    var int ItemID;
    var INT64 Count;
    var int Enchant;
};

struct _attendanceData
{
    var int Month;
    var int premium;
    var int currentDay;
    var int periodStart;
    var int PeriodEnd;
    var int WaitingTime;
};

function array<_attendanceItem> getDefaultRewardByMonth(int Month)
{
    local int i;
    local array<_attendanceItem> slots;
    local array<string> rewardData, rewardSlot;
    local string rewardLine;

    GetINIStringPrefixed("default_reward_list", string(Month), rewardLine, "AttendanceReward.dat");
    rewardData = Arr(rewardLine, ";");
    slots.Length = rewardData.Length;
    i = 0;
    J0x65:

    // End:0xEA [Loop If]
    if(i < rewardData.Length)
    {
        rewardSlot = Arr(rewardData[i], ",");
        slots[i].ItemID = int(rewardSlot[0]);
        slots[i].Count = (int(rewardSlot[1]));
        slots[i].Enchant = int(rewardSlot[2]);
        i++;
        // [Loop Continue]
        goto J0x65;
    }
    return slots;
    return;
}

function array<_attendanceItem> getPremiumRewardByMonth(int Month)
{
    local int i;
    local array<_attendanceItem> slots;
    local array<string> rewardData, rewardSlot;
    local string rewardLine;

    GetINIStringPrefixed("premium_reward_list", string(Month), rewardLine, "AttendanceReward.dat");
    rewardData = Arr(rewardLine, ";");
    slots.Length = rewardData.Length;
    i = 0;
    J0x65:

    // End:0xEA [Loop If]
    if(i < rewardData.Length)
    {
        rewardSlot = Arr(rewardData[i], ",");
        slots[i].ItemID = int(rewardSlot[0]);
        slots[i].Count = (int(rewardSlot[1]));
        slots[i].Enchant = int(rewardSlot[2]);
        i++;
        // [Loop Continue]
        goto J0x65;
    }
    return slots;
    return;
}

function int getActiveMonth()
{
    local int nActiveMonth;

    GetINIIntPrefixed("attendance", "active_month", nActiveMonth, "AttendanceReward.dat");
    return nActiveMonth;
    return;
}

function requestAttendance()
{
    RequestBypassToServer("attendui");
    return;
}

function requestChangePage(int page)
{
    RequestBypassToServer("attendpage" @ string(page));
    return;
}

function requestReward(int rewardID)
{
    RequestBypassToServer("attendclaim" @ string(rewardID));
    return;
}

function requestBuyPremium()
{
    RequestBypassToServer("showms" @ string(77501));
    return;
}
