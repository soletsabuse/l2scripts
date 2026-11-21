class ClanGfxWnd extends L2UIGFxScript;

function OnRegisterEvent()
{
    RegisterGFxEvent(10350);
    RegisterGFxEvent(10360);
    RegisterGFxEvent(10370);
    RegisterGFxEvent(10420);
    RegisterGFxEvent(10430);
    RegisterGFxEvent(10450);
    RegisterGFxEvent(10460);
    RegisterGFxEvent(10470);
    RegisterGFxEvent(10480);
    RegisterGFxEvent(10490);
    RegisterGFxEvent(10500);
    RegisterGFxEvent(10510);
    RegisterGFxEvent(10520);
    RegisterGFxEvent(10530);
    RegisterGFxEvent(10540);
    RegisterGFxEvent(10550);
    RegisterGFxEvent(10560);
    RegisterGFxEvent(10570);
    RegisterGFxEvent(10590);
    RegisterGFxEvent(10600);
    RegisterGFxEvent(10610);
    RegisterGFxEvent(10620);
    RegisterGFxEvent(10630);
    RegisterGFxEvent(10640);
    RegisterGFxEvent(10650);
    RegisterGFxEvent(10660);
    RegisterGFxEvent(10580);
    RegisterGFxEvent(10710);
    RegisterGFxEvent(10720);
    RegisterGFxEvent(10730);
    RegisterGFxEvent(10740);
    RegisterGFxEvent(10670);
    RegisterGFxEvent(10680);
    RegisterGFxEvent(10690);
    RegisterGFxEvent(10750);
    RegisterGFxEvent(10760);
    RegisterGFxEvent(10770);
    RegisterGFxEvent(10780);
    RegisterGFxEvent(10790);
    RegisterGFxEvent(10830);
    RegisterGFxEvent(10840);
    RegisterGFxEvent(10850);
    RegisterGFxEvent(10451);
    RegisterGFxEvent(150);
    RegisterGFxEvent(160);
    RegisterGFxEventForLoaded(40);
    return;
}

function OnLoad()
{
    AddState("GAMINGSTATE");
    SetContainerWindow("SkinnedWindow", 7285);
    return;
}

function OnFlashLoaded()
{
    RegisterDelegateHandler(35);
    return;
}

function OnShow()
{
    getInstanceL2Util().checkIsPrologueGrowType(string(self));
    return;
}

function OnCallUCFunction(string funcName, string param)
{
    local FileRegisterWnd script;
    local string strParam;

    Debug("funcName:" @ funcName);
    Debug("param:" @ param);
    // End:0x8E
    if(funcName == "FileRegisterWndShowByTypeStr")
    {
        script = FileRegisterWnd(GetScript("FileRegisterWnd"));
        script.FileRegisterWndShowByTypeStr(param);        
    }
    else
    {
        // End:0xBF
        if(funcName == "pledgepenalty")
        {
            ExecuteCommandFromAction("pledgepenalty");            
        }
        else
        {
            // End:0x14A
            if(funcName == "ClanSearch")
            {
                // End:0x111
                if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ClanSearch"))
                {
                    Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ClanSearch");                    
                }
                else
                {
                    Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ClanSearch");
                    Class'NWindow.UIAPI_WINDOW'.static.SetFocus("ClanSearch");
                }                
            }
            else
            {
                // End:0x1DA
                if(funcName == "ClanShopWnd")
                {
                    // End:0x19F
                    if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ClanShopWnd"))
                    {
                        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ClanShopWnd");                        
                    }
                    else
                    {
                        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ClanShopWnd");
                        Class'NWindow.UIAPI_WINDOW'.static.SetFocus("ClanShopWnd");
                    }                    
                }
                else
                {
                    // End:0x27E
                    if(funcName == "ToDoListClanWnd")
                    {
                        // End:0x23B
                        if(Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("ToDoListClanWnd"))
                        {
                            Class'NWindow.UIAPI_WINDOW'.static.HideWindow("ToDoListClanWnd");                            
                        }
                        else
                        {
                            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("ToDoListClanWnd");
                            Class'NWindow.UIAPI_WINDOW'.static.SetFocus("ToDoListClanWnd");
                        }                        
                    }
                    else
                    {
                        // End:0x2AD
                        if(funcName == "InviteFriend")
                        {
                            Class'NWindow.PersonalConnectionAPI'.static.RequestAddFriend(param);                            
                        }
                        else
                        {
                            // End:0x2D2
                            if(funcName == "InviteParty")
                            {
                                RequestInviteParty(param);                                
                            }
                            else
                            {
                                // End:0x317
                                if(funcName == "ClanBoard")
                                {
                                    strParam = "";
                                    ParamAdd(strParam, "Index", "3");
                                    ExecuteEvent(1190, strParam);                                    
                                }
                                else
                                {
                                    // End:0x33E
                                    if(funcName == "ClanHelp")
                                    {
                                        ExecuteEvent(1210, "147");                                        
                                    }
                                    else
                                    {
                                        // End:0x364
                                        if(funcName == "benefit")
                                        {
                                            ExecuteEvent(1210, "153");                                            
                                        }
                                        else
                                        {
                                            // End:0x377
                                            if(funcName == "agit")
                                            {                                                
                                            }
                                            else
                                            {
                                                // End:0x3A3
                                                if(funcName == "addFriend")
                                                {
                                                    Class'NWindow.PersonalConnectionAPI'.static.RequestAddFriend(param);                                                    
                                                }
                                                else
                                                {
                                                    // End:0x3C8
                                                    if(funcName == "inviteParty")
                                                    {
                                                        RequestInviteParty(param);                                                        
                                                    }
                                                    else
                                                    {
                                                        // End:0x3E6
                                                        if(funcName == "whisper")
                                                        {
                                                            whisperToUser(param);
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return;
}

function whisperToUser(string Username)
{
    local ChatWnd chatWndScript;

    // End:0x44
    if(Username != "")
    {
        chatWndScript = ChatWnd(GetScript("ChatWnd"));
        chatWndScript.setChatEditBox(("\"" $ Username) $ " ");
    }
    return;
}
