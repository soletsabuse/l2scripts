class QuestListWnd extends UIScript;

var WindowHandle Me;
var ListCtrlHandle lstQuest;
var TextureHandle QuestTooltip;

function OnRegisterEvent()
{
    RegisterEvent(2840);
    RegisterEvent(2850);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    // End:0x13
    if(1 == 0)
    {
        OnRegisterEvent();
    }
    // End:0x8B
    if(1 == 0)
    {
        Me = GetHandle("QuestListWnd");
        QuestTooltip = TextureHandle(GetHandle("QuestListWnd.QuestTooltip"));
        lstQuest = ListCtrlHandle(GetHandle("QuestListWnd.lstQuest"));        
    }
    else
    {
        Me = GetWindowHandle("QuestListWnd");
        QuestTooltip = GetTextureHandle("QuestListWnd.QuestTooltip");
        lstQuest = GetListCtrlHandle("QuestListWnd.lstQuest");
    }
    InitQuestTooltip();
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x18
        case 2840:
            HandleQuestInfoStart();
            // End:0x31
            break;
        // End:0x2E
        case 2850:
            HandleQuestInfo(param);
            // End:0x31
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x1B
        case "btnLoc":
            ShowQuestTarget();
            // End:0x1E
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickListCtrlRecord(string Id)
{
    local int idx, questID, NpcID;
    local string strTargetName;
    local Vector vTargetPos;
    local LVDataRecord Record;

    // End:0xED
    if(Id == "lstQuest")
    {
        idx = lstQuest.GetSelectedIndex();
        // End:0x63
        if(idx > -1)
        {
            lstQuest.GetRec(idx, Record);
            questID = name(Record.nReserved1);
        }
        // End:0xED
        if(questID > 0)
        {
            NpcID = Class'NWindow.UIDATA_QUEST'.static.GetStartNPCID(questID, 1);
            strTargetName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(NpcID);
            vTargetPos = Class'NWindow.UIDATA_QUEST'.static.GetStartNPCLoc(questID, 1);
            // End:0xED
            if(Len(strTargetName) > 0)
            {
                Class'NWindow.QuestAPI'.static.SetQuestTargetInfo(true, true, true, strTargetName, vTargetPos, questID, 1);
            }
        }
    }
    return;
}

function HandleQuestInfoStart()
{
    lstQuest.DeleteAllItem();
    Me.ShowWindow();
    Me.SetFocus();
    return;
}

function HandleQuestInfo(string param)
{
    local int questID;
    local string QuestName, QuestRequirement, QuestLevel;
    local int QuestType;
    local string QuestNpcName, QuestDecription, TempTxt;
    local LVDataRecord Record;

    ParseInt(param, "QuestID", questID);
    ParseString(param, "QuestName", QuestName);
    ParseString(param, "QuestRequirement", QuestRequirement);
    ParseString(param, "QuestLevel", QuestLevel);
    ParseInt(param, "QuestType", QuestType);
    ParseString(param, "QuestNpcName", QuestNpcName);
    ParseString(param, "QuestDecription", QuestDecription);
    // End:0x103
    if((QuestNpcName == "") || QuestNpcName == "None")
    {
        TempTxt = GetSystemString(27);
        QuestNpcName = TempTxt;
    }
    Record.LVDataList.Length = 5;
    Record.LVDataList[0].szData = QuestName;
    Record.LVDataList[1].szData = QuestRequirement;
    Record.LVDataList[2].szData = QuestLevel;
    Record.LVDataList[3].nTextureWidth = 16;
    Record.LVDataList[3].nTextureHeight = 16;
    switch(QuestType)
    {
        // End:0x18C
        case 0:
        // End:0x1E3
        case 2:
            Record.LVDataList[3].szTexture = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_1";
            Record.LVDataList[3].szData = "1";
            // End:0x29D
            break;
        // End:0x1E7
        case 1:
        // End:0x23E
        case 3:
            Record.LVDataList[3].szTexture = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_2";
            Record.LVDataList[3].szData = "2";
            // End:0x29D
            break;
        // End:0x243
        case 4:
        // End:0x29A
        case 5:
            Record.LVDataList[3].szTexture = "L2UI_CH3.QUESTWND.QuestWndInfoIcon_3";
            Record.LVDataList[3].szData = "3";
            // End:0x29D
            break;
        // End:0xFFFF
        default:
            break;
    }
    Record.LVDataList[3].nReserved1 = QuestType;
    Record.LVDataList[4].szData = QuestNpcName;
    Record.szReserved = QuestDecription;
    Record.nReserved1 = (questID);
    lstQuest.InsertRecord(Record);
    return;
}

function ShowQuestTarget()
{
    local int idx, questID, NpcID;
    local string strTargetName;
    local Vector vTargetPos;
    local MinimapWnd script;
    local LVDataRecord Record;
    local WindowHandle Me;

    script = MinimapWnd(GetScript("MinimapWnd"));
    Me = GetWindowHandle("MinimapWnd");
    idx = lstQuest.GetSelectedIndex();
    // End:0x84
    if(idx > -1)
    {
        lstQuest.GetRec(idx, Record);
        questID = name(Record.nReserved1);
    }
    // End:0x140
    if(questID > 0)
    {
        NpcID = Class'NWindow.UIDATA_QUEST'.static.GetStartNPCID(questID, 1);
        strTargetName = Class'NWindow.UIDATA_NPC'.static.GetNPCName(NpcID);
        vTargetPos = Class'NWindow.UIDATA_QUEST'.static.GetStartNPCLoc(questID, 1);
        // End:0x140
        if(Len(strTargetName) > 0)
        {
            Class'NWindow.QuestAPI'.static.SetQuestTargetInfo(true, true, true, strTargetName, vTargetPos, questID, 1);
            // End:0x131
            if(!Me.IsShowWindow())
            {
                Me.ShowWindow();
            }
            script.OnClickTargetButton();
        }
    }
    return;
}

function InitQuestTooltip()
{
    local CustomTooltip TooltipInfo;

    TooltipInfo.DrawList.Length = 6;
    TooltipInfo.DrawList[0].eType = 2;
    TooltipInfo.DrawList[0].u_nTextureWidth = 16;
    TooltipInfo.DrawList[0].u_nTextureHeight = 16;
    TooltipInfo.DrawList[0].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_1";
    TooltipInfo.DrawList[1].eType = 1;
    TooltipInfo.DrawList[1].nOffSetX = 5;
    TooltipInfo.DrawList[1].t_bDrawOneLine = true;
    TooltipInfo.DrawList[1].t_strText = GetSystemString(861);
    TooltipInfo.DrawList[2].eType = 2;
    TooltipInfo.DrawList[2].nOffSetY = 2;
    TooltipInfo.DrawList[2].u_nTextureWidth = 16;
    TooltipInfo.DrawList[2].u_nTextureHeight = 16;
    TooltipInfo.DrawList[2].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_2";
    TooltipInfo.DrawList[2].bLineBreak = true;
    TooltipInfo.DrawList[3].eType = 1;
    TooltipInfo.DrawList[3].nOffSetY = 2;
    TooltipInfo.DrawList[3].nOffSetX = 5;
    TooltipInfo.DrawList[3].t_bDrawOneLine = true;
    TooltipInfo.DrawList[3].t_strText = GetSystemString(862);
    TooltipInfo.DrawList[4].eType = 2;
    TooltipInfo.DrawList[4].nOffSetY = 2;
    TooltipInfo.DrawList[4].u_nTextureWidth = 16;
    TooltipInfo.DrawList[4].u_nTextureHeight = 16;
    TooltipInfo.DrawList[4].u_strTexture = "L2UI_CH3.QuestWnd.QuestWndInfoIcon_3";
    TooltipInfo.DrawList[4].bLineBreak = true;
    TooltipInfo.DrawList[5].eType = 1;
    TooltipInfo.DrawList[5].nOffSetY = 2;
    TooltipInfo.DrawList[5].nOffSetX = 5;
    TooltipInfo.DrawList[5].t_bDrawOneLine = true;
    TooltipInfo.DrawList[5].t_strText = GetSystemString(2788);
    QuestTooltip.SetTooltipCustomType(TooltipInfo);
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle("QuestListWnd").HideWindow();
    return;
}
