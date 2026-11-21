class PlayerPortStatisticObject extends PlayerPortPacket
    config(Engine)
    perobjectconfig;

struct sStatistic
{
    var INT64 expEarned;
    var INT64 expSpent;
    var int spEarned;
    var int spSpent;
    var INT64 adenaEarned;
    var INT64 adenaSpent;
    var INT64 colEarned;
    var INT64 colSpent;
    var int pvpEarned;
    var int pkEarned;
    var int dyingCount;
};

var bool bStatisticPlayerLoaded;
var bool bStatisticItemsLoaded;
var int nStatisticCurrentSubClass;
var sStatistic Statistic;
var INT64 lastExp;
var INT64 lastSP;
var INT64 lastAdena;
var INT64 lastCOL;
var int lastPVP;
var int lastPK;

function HandleUserInfo()
{
    // End:0x12
    if(!GetPlayerInfo(Owner))
    {
        return;
    }
    // End:0x30
    if(nStatisticCurrentSubClass != Owner.nSubClass)
    {
        setStatisticFlag(false);        
    }
    else
    {
        // End:0x43
        if((isLevelChanged()) > 1)
        {
            setStatisticFlag(false);
        }
    }
    // End:0xAB
    if(!getStatisticFlag())
    {
        setStatisticFlag(true);
        clearStatistic();
        nStatisticCurrentSubClass = Owner.nSubClass;
        lastExp = Owner.nCurExp;
        lastSP = Owner.nSP;
        lastPVP = Owner.nDualCount;
        lastPK = Owner.nPKCount;
    }
    updateExp(Owner);
    updateSp(Owner);
    updatePvP(Owner);
    updatePK(Owner);
    return;
}

function handleAdenaInvenCount(string param)
{
    local INT64 Adena;
    local ItemInfo item;

    // End:0x0B
    if(bStatisticItemsLoaded)
    {
        return;
    }
    ParseINT64(param, "Adena", Adena);
    item = getStatisticUpdatableItem(4037);
    bStatisticItemsLoaded = true;
    lastAdena = Adena;
    lastCOL = item.ItemNum;
    return;
}

function handleInventoryUpdate(string param)
{
    local string Type;
    local ItemInfo item;

    ParseItemID(param, item.Id);
    ParseINT64(param, "itemNum", item.ItemNum);
    // End:0x4C
    if(isStatisticCurrencyUpdatableItem(item))
    {
        validateStatisticCurrencyUpdatableItem(item);
    }
    return;
}

function updateExp(UserInfo Player)
{
    local INT64 diff;

    // End:0x0D
    if(!getStatisticFlag())
    {
        return;
    }
    diff = __NFUN_405__(Player.nCurExp, lastExp);
    // End:0x35
    if(__NFUN_412__(diff, (0)))
    {
        return;
    }
    // End:0x58
    if(__NFUN_409__(diff, (0)))
    {
        __NFUN_406__(Statistic.expEarned, diff);        
    }
    else
    {
        // End:0x78
        if(__NFUN_408__(diff, (0)))
        {
            __NFUN_407__(Statistic.expSpent, diff);
        }
    }
    lastExp = Player.nCurExp;
    return;
}

function updateSp(UserInfo Player)
{
    local INT64 diff;

    // End:0x0D
    if(!getStatisticFlag())
    {
        return;
    }
    diff = __NFUN_405__(Player.nSP, lastSP);
    // End:0x35
    if(__NFUN_412__(diff, (0)))
    {
        return;
    }
    // End:0x59
    if(__NFUN_409__(diff, (0)))
    {
        Statistic.spEarned += name(diff);        
    }
    else
    {
        // End:0x7A
        if(__NFUN_408__(diff, (0)))
        {
            Statistic.spSpent -= name(diff);
        }
    }
    lastSP = Player.nSP;
    return;
}

function updatePvP(UserInfo Player)
{
    local INT64 diff;

    // End:0x0D
    if(!getStatisticFlag())
    {
        return;
    }
    diff = (Player.nDualCount - lastPVP);
    // End:0x36
    if(__NFUN_412__(diff, (0)))
    {
        return;
    }
    // End:0x4F
    if(__NFUN_412__(diff, (Player.nDualCount)))
    {
        return;
    }
    // End:0x70
    if(__NFUN_409__(diff, (0)))
    {
        Statistic.pvpEarned += name(diff);
    }
    lastPVP = Player.nDualCount;
    return;
}

function updatePK(UserInfo Player)
{
    local INT64 diff;

    // End:0x0D
    if(!getStatisticFlag())
    {
        return;
    }
    diff = (Player.nPKCount - lastPK);
    // End:0x36
    if(__NFUN_412__(diff, (0)))
    {
        return;
    }
    // End:0x4F
    if(__NFUN_412__(diff, (Player.nPKCount)))
    {
        return;
    }
    // End:0x70
    if(__NFUN_409__(diff, (0)))
    {
        Statistic.pkEarned += name(diff);
    }
    lastPK = Player.nPKCount;
    return;
}

function updateDying()
{
    Statistic.dyingCount += 1;
    return;
}

function Dying(bool bDying)
{
    // End:0x37
    if(!bDying)
    {
        // End:0x34
        if(GetPlayerInfo(Owner))
        {
            // End:0x34
            if(Owner.nCurHP > 0)
            {
                bImDied = false;
                SaveConfig();
            }
        }        
    }
    else
    {
        // End:0x53
        if(!bImDied)
        {
            bImDied = true;
            SaveConfig();
            updateDying();
        }
    }
    return;
}

function validateStatisticCurrencyUpdatableItem(ItemInfo item)
{
    local INT64 diff;

    // End:0x0D
    if(!bStatisticItemsLoaded)
    {
        return;
    }
    switch(item.Id.ClassID)
    {
        // End:0xA1
        case 57:
            diff = __NFUN_405__(item.ItemNum, lastAdena);
            // End:0x4B
            if(__NFUN_412__(diff, (0)))
            {
                return;
            }
            // End:0x6E
            if(__NFUN_409__(diff, (0)))
            {
                __NFUN_406__(Statistic.adenaEarned, diff);                
            }
            else
            {
                // End:0x8E
                if(__NFUN_408__(diff, (0)))
                {
                    __NFUN_407__(Statistic.adenaSpent, diff);
                }
            }
            lastAdena = item.ItemNum;
            // End:0x12D
            break;
        // End:0x127
        case 4037:
            diff = __NFUN_405__(item.ItemNum, lastCOL);
            // End:0xD1
            if(__NFUN_412__(diff, (0)))
            {
                return;
            }
            // End:0xF4
            if(__NFUN_409__(diff, (0)))
            {
                __NFUN_406__(Statistic.colEarned, diff);                
            }
            else
            {
                // End:0x114
                if(__NFUN_408__(diff, (0)))
                {
                    __NFUN_407__(Statistic.colSpent, diff);
                }
            }
            lastCOL = item.ItemNum;
            // End:0x12D
            break;
        // End:0xFFFF
        default:
            // End:0x12D
            break;
            break;
    }
    return;
}

function bool isStatisticUpdatableItem(ItemInfo item)
{
    switch(item.Id.ClassID)
    {
        // End:0x19
        case 5591:
        // End:0x23
        case 5592:
            return true;
        // End:0xFFFF
        default:
            return false;
            break;
    }    
    return;
}

function bool isStatisticCurrencyUpdatableItem(ItemInfo item)
{
    switch(item.Id.ClassID)
    {
        // End:0x16
        case 57:
        // End:0x20
        case 4037:
            return true;
        // End:0xFFFF
        default:
            return false;
            break;
    }    
    return;
}

function ItemInfo getStatisticUpdatableItem(int ClassID)
{
    local int i, ItemCount;
    local array<ItemInfo> tmpItemArray;

    ItemCount = Class'NWindow.UIDATA_INVENTORY'.static.FindItemByClassID(ClassID, tmpItemArray);
    i = 0;
    J0x26:

    // End:0x6A [Loop If]
    if(i < ItemCount)
    {
        // End:0x60
        if(tmpItemArray[i].Id.ClassID == ClassID)
        {
            return tmpItemArray[i];
        }
        i++;
        // [Loop Continue]
        goto J0x26;
    }
    return;
}

function clearStatistic()
{
    local sStatistic clearStatistic;

    Statistic = clearStatistic;
    return;
}

function bool getStatisticFlag()
{
    return bStatisticPlayerLoaded;
    return;
}

function setStatisticFlag(bool bFlag)
{
    bStatisticPlayerLoaded = bFlag;
    return;
}
