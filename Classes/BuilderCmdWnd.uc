class BuilderCmdWnd extends UICommonAPI;

var string m_WindowName;
var WindowHandle Me;
var ButtonHandle collision_button;
var ButtonHandle npcinfo_button;
var ButtonHandle stat_button;
var ButtonHandle rmode_button;
var ButtonHandle bonename_button;
var ButtonHandle init_button;
var ComboBoxHandle Reload_ComboBox;
var ButtonHandle Reload_button;
var ButtonHandle AVE_button;
var ButtonHandle NpcSummon_Button;
var ButtonHandle UseSkill_button;
var ButtonHandle DefaultNpc_button;
var ButtonHandle ComeOn_button;
var ButtonHandle KillNpc_button;
var ButtonHandle SetParam_button;
var ButtonHandle Ride_button;
var ButtonHandle SetSpeed_button;
var ButtonHandle SetRace_button;
var ButtonHandle Clone_button;
var ButtonHandle JobTree_button;
var ButtonHandle Search_Button;
var ComboBoxHandle Race_ComboBox;
var ComboBoxHandle Sex_ComboBox;
var EditBoxHandle AveId_EditBox;
var EditBoxHandle NpcId_EditBox;
var EditBoxHandle SkillId_EditBox;
var EditBoxHandle Param_EditBox;
var EditBoxHandle RideId_EditBox;
var EditBoxHandle Speed_EditBox;
var SliderCtrlHandle sliderSetTime;
var TextBoxHandle txtSetTime;
var CheckBoxHandle checkBoxSetTime;

function OnLoad()
{
    SetClosingOnESC();
    Me = GetWindowHandle("BuilderCmdWnd");
    Me.SetWindowTitle("BuilderCommand");
    collision_button = GetButtonHandle("BuilderCmdWnd.Group1.collision_button");
    npcinfo_button = GetButtonHandle("BuilderCmdWnd.Group1.npcinfo_button");
    stat_button = GetButtonHandle("BuilderCmdWnd.Group1.stat_button");
    rmode_button = GetButtonHandle("BuilderCmdWnd.Group1.rmode_button");
    bonename_button = GetButtonHandle("BuilderCmdWnd.Group1.bonename_button");
    init_button = GetButtonHandle("BuilderCmdWnd.Group1.init_button");
    Reload_ComboBox = GetComboBoxHandle("BuilderCmdWnd.Group2.Reload_ComboBox");
    Reload_ComboBox.AddString("AdditionalEffect");
    Reload_ComboBox.AddString("ArmorGrp");
    Reload_ComboBox.AddString("WeaponGrp");
    Reload_ComboBox.AddString("EtcItemGrp");
    Reload_ComboBox.AddString("SkillGrp");
    Reload_ComboBox.AddString("NpcGrp");
    Reload_ComboBox.AddString("HairExGrp");
    Reload_ComboBox.AddString("FaceExGrp");
    Reload_ComboBox.AddString("----------------");
    Reload_ComboBox.AddString("Skill_Data");
    Reload_ComboBox.AddString("Item_Data");
    Reload_ComboBox.AddString("Npc_Data");
    Reload_ComboBox.AddString("----------------");
    Reload_ComboBox.AddString("Effect");
    Reload_ComboBox.AddString("SkillEffect");
    Reload_ComboBox.AddString("LineageNpc*");
    Reload_ComboBox.AddString("LineageMonster*");
    Reload_ComboBox.AddString("LineageWarrior");
    AVE_button = GetButtonHandle("BuilderCmdWnd.Group3.AVE_button");
    AveId_EditBox = GetEditBoxHandle("BuilderCmdWnd.Group3.AveId_EditBox");
    AveId_EditBox.SetString("68");
    NpcSummon_Button = GetButtonHandle("BuilderCmdWnd.Group4.NpcSummon_Button");
    NpcId_EditBox = GetEditBoxHandle("BuilderCmdWnd.Group4.NpcId_EditBox");
    NpcId_EditBox.SetString("18002");
    UseSkill_button = GetButtonHandle("BuilderCmdWnd.Group4.UseSkill_button");
    SkillId_EditBox = GetEditBoxHandle("BuilderCmdWnd.Group4.SkillId_EditBox");
    SkillId_EditBox.SetString("129 1 0");
    DefaultNpc_button = GetButtonHandle("BuilderCmdWnd.Group4.DefaultNpc_button");
    ComeOn_button = GetButtonHandle("BuilderCmdWnd.Group4.ComeOn_button");
    KillNpc_button = GetButtonHandle("BuilderCmdWnd.Group4.KillNpc_button");
    Ride_button = GetButtonHandle("BuilderCmdWnd.Group5.Ride_button");
    SetParam_button = GetButtonHandle("BuilderCommand.Group5.SetParam_button");
    SetSpeed_button = GetButtonHandle("BuilderCmdWnd.Group5.SetSpeed_button");
    Search_Button = GetButtonHandle("BuilderCmdWnd.Group5.search_button");
    Race_ComboBox = GetComboBoxHandle("BuilderCmdWnd.Group5.Race_ComboBox");
    Race_ComboBox.AddString(GetSystemString(170) $ GetSystemString(175));
    Race_ComboBox.AddString(GetSystemString(170) $ GetSystemString(176));
    Race_ComboBox.AddString(GetSystemString(171) $ GetSystemString(175));
    Race_ComboBox.AddString(GetSystemString(171) $ GetSystemString(176));
    Race_ComboBox.AddString(GetSystemString(172) $ GetSystemString(175));
    Race_ComboBox.AddString(GetSystemString(172) $ GetSystemString(176));
    Race_ComboBox.AddString(GetSystemString(173) $ GetSystemString(175));
    Race_ComboBox.AddString(GetSystemString(173) $ GetSystemString(176));
    Race_ComboBox.SYS_AddString(174);
    Race_ComboBox.SYS_AddString(1544);
    Race_ComboBox.AddString(GetSystemString(3273) $ GetSystemString(175));
    Race_ComboBox.AddString(GetSystemString(3273) $ GetSystemString(176));
    Sex_ComboBox = GetComboBoxHandle("BuilderCmdWnd.Group5.Sex_ComboBox");
    Sex_ComboBox.SYS_AddString(177);
    Sex_ComboBox.SYS_AddString(178);
    RideId_EditBox = GetEditBoxHandle("BuilderCmdWnd.Group5.RideId_EditBox");
    RideId_EditBox.SetString("13522");
    Param_EditBox = GetEditBoxHandle("BuilderCmdWnd.Group5.Param_EditBox");
    Param_EditBox.SetString("lv 80");
    Speed_EditBox = GetEditBoxHandle("BuilderCmdWnd.Group5.Speed_EditBox");
    Speed_EditBox.SetString("10");
    Clone_button = GetButtonHandle("BuilderCmdWnd.Group6.Clone_button");
    JobTree_button = GetButtonHandle("BuilderCmdWnd.Group6.JobTree_button");
    sliderSetTime = GetSliderCtrlHandle("BuilderCmdWnd.Group6.sliderSetTime");
    txtSetTime = GetTextBoxHandle("BuilderCmdWnd.Group6.txtSetTime");
    checkBoxSetTime = GetCheckBoxHandle("BuilderCmdWnd.Group6.checkBoxSetTime");
    return;
}

function OnClickReloadButton()
{
    local int selected;

    selected = Reload_ComboBox.GetSelectedNum();
    switch(selected)
    {
        // End:0x45
        case 0:
            ExecuteCommand("///additionaleffect_reload");
            // End:0x23F
            break;
        // End:0x66
        case 1:
            ExecuteCommand("///armorgrp_reload");
            // End:0x23F
            break;
        // End:0x89
        case 2:
            ExecuteCommand("///weapongrp_reload");
            // End:0x23F
            break;
        // End:0xAD
        case 3:
            ExecuteCommand("///etcitemgrp_reload");
            // End:0x23F
            break;
        // End:0xCF
        case 4:
            ExecuteCommand("///skillgrp_reload");
            // End:0x23F
            break;
        // End:0xEF
        case 5:
            ExecuteCommand("///npcgrp_reload");
            // End:0x23F
            break;
        // End:0x112
        case 6:
            ExecuteCommand("///hairexgrp_reload");
            // End:0x23F
            break;
        // End:0x135
        case 7:
            ExecuteCommand("///faceexgrp_reload");
            // End:0x23F
            break;
        // End:0x13D
        case 8:
            // End:0x23F
            break;
        // End:0x160
        case 9:
            ExecuteCommand("//reload_skill_data");
            // End:0x23F
            break;
        // End:0x182
        case 10:
            ExecuteCommand("//reload_item_data");
            // End:0x23F
            break;
        // End:0x1A3
        case 11:
            ExecuteCommand("//reload_npc_data");
            // End:0x23F
            break;
        // End:0x1AB
        case 12:
            // End:0x23F
            break;
        // End:0x1C5
        case 13:
            ExecuteCommand("///reloade");
            // End:0x23F
            break;
        // End:0x1E0
        case 14:
            ExecuteCommand("///reloadse");
            // End:0x23F
            break;
        // End:0x1FC
        case 15:
            ExecuteCommand("///reloadnpc");
            // End:0x23F
            break;
        // End:0x21C
        case 16:
            ExecuteCommand("///reloadmonster");
            // End:0x23F
            break;
        // End:0x23C
        case 17:
            ExecuteCommand("///reloadwarrior");
            // End:0x23F
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickButton(string a_ButtonID)
{
    switch(a_ButtonID)
    {
        // End:0x22
        case "Reload_button":
            OnClickReloadButton();
            // End:0x568
            break;
        // End:0x4F
        case "collision_button":
            ExecuteCommand("///show radii");
            // End:0x568
            break;
        // End:0x76
        case "npcinfo_button":
            ExecuteCommand("//debug .");
            // End:0x568
            break;
        // End:0xA0
        case "nameTag_button":
            ExecuteCommand("///show name");
            // End:0x568
            break;
        // End:0xC5
        case "stat_button":
            ExecuteCommand("///stat l2");
            // End:0x568
            break;
        // End:0x152
        case "rmode_button":
            // End:0x123
            if(rmode_button.GetButtonName() == "Wireframe")
            {
                ExecuteCommand("///rmode 1");
                rmode_button.SetNameText("Lighting");                
            }
            else
            {
                ExecuteCommand("///rmode 5");
                rmode_button.SetNameText("Wireframe");
            }
            // End:0x568
            break;
        // End:0x195
        case "bonename_button":
            ExecuteCommand("///rend bone");
            ExecuteCommand("///rend bonename");
            // End:0x568
            break;
        // End:0x22B
        case "init_button":
            ExecuteCommand("//hide off");
            ExecuteCommand("//undying on");
            ExecuteCommand("//set_skill_all_me");
            ExecuteCommand("//skill_master on");
            ExecuteCommand("//item_master on");
            ExecuteCommand("///autocom");
            // End:0x568
            break;
        // End:0x2C2
        case "AVE_button":
            // End:0x293
            if(AVE_button.GetButtonName() == "Show")
            {
                ExecuteCommand("///aa type=" @ AveId_EditBox.GetString());
                AVE_button.SetNameText("Hide");
                // End:0x568
                break;                
            }
            else
            {
                ExecuteCommand("///aa type=none");
                AVE_button.SetNameText("Show");
                // End:0x568
                break;
            }
        // End:0x2FE
        case "NpcSummon_Button":
            ExecuteCommand("//summon 10" $ NpcId_EditBox.GetString());
            // End:0x568
            break;
        // End:0x33D
        case "UseSkill_Button":
            ExecuteCommand("//npc_use_skill" @ SkillId_EditBox.GetString());
            // End:0x568
            break;
        // End:0x371
        case "DefaultNpc_button":
            ExecuteCommand("//setai default_npc");
            // End:0x568
            break;
        // End:0x39C
        case "ComeOn_Button":
            ExecuteCommand("//come_to_me 1");
            // End:0x568
            break;
        // End:0x3C3
        case "KillNpc_Button":
            ExecuteCommand("//killnpc");
            // End:0x568
            break;
        // End:0x3FE
        case "SetParam_button":
            ExecuteCommand("//setparam " @ Param_EditBox.GetString());
            // End:0x568
            break;
        // End:0x492
        case "Ride_button":
            // End:0x469
            if(Ride_button.GetButtonName() == "Ride")
            {
                ExecuteCommand("///ride id=" @ RideId_EditBox.GetString());
                Ride_button.SetNameText("Unride");
                // End:0x568
                break;                
            }
            else
            {
                ExecuteCommand("///unride");
                Ride_button.SetNameText("Ride");
                // End:0x568
                break;
            }
        // End:0x4CB
        case "SetSpeed_button":
            ExecuteCommand("//gmspeed" @ Speed_EditBox.GetString());
            // End:0x568
            break;
        // End:0x4FC
        case "Clone_button":
            ExecuteCommand("///spawnpc copy num=1");
            // End:0x568
            break;
        // End:0x539
        case "JobTree_button":
            ExecuteCommand("/target %self");
            ShowWindow("JobTreeWnd");
            // End:0x568
            break;
        // End:0x565
        case "Search_button":
            ExecuteCommand("///searchobject");
            // End:0x568
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnModifyCurrentTickSliderCtrl(string strID, int iCurrentTick)
{
    local float ftime;

    switch(strID)
    {
        // End:0x6D
        case "sliderSetTime":
            // End:0x6A
            if(checkBoxSetTime.IsChecked())
            {
                ftime = float(sliderSetTime.GetCurrentTick()) / 10.0000000;
                SetEnvTime(ftime);
                txtSetTime.SetText(string(ftime));
            }
            // End:0x70
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnComboBoxItemSelected(string strID, int IndexID)
{
    switch(strID)
    {
        // End:0x314
        case "Race_ComboBox":
            switch(IndexID)
            {
                // End:0x57
                case 0:
                    ExecuteCommand("/target %self");
                    ExecuteCommand("//setparam race 0 0");
                    // End:0x311
                    break;
                // End:0x8E
                case 1:
                    ExecuteCommand("/target %self");
                    ExecuteCommand("//setparam race 0 1");
                    // End:0x311
                    break;
                // End:0xC6
                case 2:
                    ExecuteCommand("/target %self");
                    ExecuteCommand("//setparam race 1 0");
                    // End:0x311
                    break;
                // End:0xFE
                case 3:
                    ExecuteCommand("/target %self");
                    ExecuteCommand("//setparam race 1 1");
                    // End:0x311
                    break;
                // End:0x136
                case 4:
                    ExecuteCommand("/target %self");
                    ExecuteCommand("//setparam race 2 0");
                    // End:0x311
                    break;
                // End:0x16E
                case 5:
                    ExecuteCommand("/target %self");
                    ExecuteCommand("//setparam race 2 1");
                    // End:0x311
                    break;
                // End:0x1A6
                case 6:
                    ExecuteCommand("/target %self");
                    ExecuteCommand("//setparam race 3 0");
                    // End:0x311
                    break;
                // End:0x1DE
                case 7:
                    ExecuteCommand("/target %self");
                    ExecuteCommand("//setparam race 3 1");
                    // End:0x311
                    break;
                // End:0x216
                case 8:
                    ExecuteCommand("/target %self");
                    ExecuteCommand("//setparam race 4 0");
                    // End:0x311
                    break;
                // End:0x24E
                case 9:
                    ExecuteCommand("/target %self");
                    ExecuteCommand("//setparam race 5 0");
                    // End:0x311
                    break;
                // End:0x2AE
                case 10:
                    ExecuteCommand("/target %self");
                    Sex_ComboBox.SetSelectedNum(1);
                    ExecuteCommand("//setparam sex 1");
                    ExecuteCommand("//setparam race 6 0");
                    // End:0x311
                    break;
                // End:0x30E
                case 11:
                    ExecuteCommand("/target %self");
                    Sex_ComboBox.SetSelectedNum(1);
                    ExecuteCommand("//setparam sex 1");
                    ExecuteCommand("//setparam race 6 1");
                    // End:0x311
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            // End:0x39D
            break;
        // End:0x39A
        case "Sex_ComboBox":
            switch(IndexID)
            {
                // End:0x360
                case 0:
                    ExecuteCommand("/target %self");
                    ExecuteCommand("//setparam sex 0");
                    // End:0x397
                    break;
                // End:0x394
                case 1:
                    ExecuteCommand("/target %self");
                    ExecuteCommand("//setparam sex 1");
                    // End:0x397
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            // End:0x39D
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnReceivedCloseUI()
{
    PlayConsoleSound(6);
    GetWindowHandle(m_WindowName).HideWindow();
    return;
}

defaultproperties
{
    m_WindowName="BuilderCmdWnd"
}