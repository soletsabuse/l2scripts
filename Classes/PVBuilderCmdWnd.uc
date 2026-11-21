class PVBuilderCmdWnd extends UICommonAPI;

var string m_WindowName;
var WindowHandle Me;
var ButtonHandle collision_button;
var ButtonHandle nameTag_button;
var ButtonHandle stat_button;
var ButtonHandle rmode_button;
var ButtonHandle bonename_button;
var ButtonHandle option_button;
var ComboBoxHandle Reload_ComboBox;
var ButtonHandle Reload_button;
var ButtonHandle AVE_button;
var ButtonHandle Effect_button;
var ButtonHandle Ride_button;
var ButtonHandle SetSpeed_button;
var ButtonHandle Teleport_button;
var ButtonHandle playermove_button;
var ButtonHandle ghost_button;
var ButtonHandle Clone_button;
var ButtonHandle pv_button;
var ButtonHandle nv_button;
var ButtonHandle sv_button;
var ButtonHandle sc_button;
var ButtonHandle Search_Button;
var ButtonHandle minimap_button;
var ComboBoxHandle Location_ComboBox;
var EditBoxHandle AveId_EditBox;
var EditBoxHandle Effect_EditBox;
var EditBoxHandle RideId_EditBox;
var EditBoxHandle OffsetX_EditBox;
var EditBoxHandle OffsetY_EditBox;
var EditBoxHandle OffsetZ_EditBox;
var EditBoxHandle Pitch_EditBox;
var EditBoxHandle Yaw_EditBox;
var EditBoxHandle Roll_EditBox;
var EditBoxHandle Speed_EditBox;
var EditBoxHandle TelX_EditBox;
var EditBoxHandle TelY_EditBox;
var EditBoxHandle TelZ_EditBox;
var EditBoxHandle Player_EditBox;
var SliderCtrlHandle sliderSetTime;
var TextBoxHandle txtSetTime;
var CheckBoxHandle checkBoxSetTime;

function OnLoad()
{
    SetClosingOnESC();
    Me = GetWindowHandle("PVBuilderCmdWnd");
    Me.SetWindowTitle("BuilderCommand");
    collision_button = GetButtonHandle("PVBuilderCmdWnd.Group1.collision_button");
    nameTag_button = GetButtonHandle("PVBuilderCmdWnd.Group1.nameTag_button");
    stat_button = GetButtonHandle("PVBuilderCmdWnd.Group1.stat_button");
    rmode_button = GetButtonHandle("PVBuilderCmdWnd.Group1.rmode_button");
    bonename_button = GetButtonHandle("PVBuilderCmdWnd.Group1.bonename_button");
    option_button = GetButtonHandle("PVBuilderCmdWnd.Group1.option_button");
    Reload_ComboBox = GetComboBoxHandle("PVBuilderCmdWnd.Group2.Reload_ComboBox");
    Reload_ComboBox.AddString("AdditionalEffect");
    Reload_ComboBox.AddString("ArmorGrp");
    Reload_ComboBox.AddString("WeaponGrp");
    Reload_ComboBox.AddString("SkillGrp");
    Reload_ComboBox.AddString("NpcGrp");
    Reload_ComboBox.AddString("HairExGrp");
    Reload_ComboBox.AddString("FaceExGrp");
    Reload_ComboBox.AddString("CharGrp");
    Reload_ComboBox.AddString("----------------");
    Reload_ComboBox.AddString("Effect");
    Reload_ComboBox.AddString("SkillEffect");
    Reload_ComboBox.AddString("LineageNpc*");
    Reload_ComboBox.AddString("LineageMonster*");
    Reload_ComboBox.AddString("LineageWarrior");
    AVE_button = GetButtonHandle("PVBuilderCmdWnd.Group3.AVE_button");
    Effect_button = GetButtonHandle("PVBuilderCmdWnd.Group3.Effect_button");
    Ride_button = GetButtonHandle("PVBuilderCmdWnd.Group4.Ride_button");
    SetSpeed_button = GetButtonHandle("PVBuilderCmdWnd.Group4.SetSpeed_button");
    Teleport_button = GetButtonHandle("PVBuilderCmdWnd.Group4.Teleport_button");
    playermove_button = GetButtonHandle("PVBuilderCmdWnd.Group4.playermove_button");
    ghost_button = GetButtonHandle("PVBuilderCmdWnd.Group4.ghost_button");
    Clone_button = GetButtonHandle("PVBuilderCmdWnd.Group4.clone_button");
    Location_ComboBox = GetComboBoxHandle("PVBuilderCmdWnd.Group4.Location_ComboBox");
    Location_ComboBox.SYS_AddString(1048);
    Location_ComboBox.SYS_AddString(1049);
    Location_ComboBox.AddString("EmptySite");
    AveId_EditBox = GetEditBoxHandle("PVBuilderCmdWnd.Group3.AveId_EditBox");
    AveId_EditBox.SetString("68");
    Effect_EditBox = GetEditBoxHandle("PVBuilderCmdWnd.Group3.Effect_EditBox");
    Effect_EditBox.SetString("z_ice_screen_f");
    RideId_EditBox = GetEditBoxHandle("PVBuilderCmdWnd.Group4.RideId_EditBox");
    RideId_EditBox.SetString("13330");
    OffsetX_EditBox = GetEditBoxHandle("PVBuilderCmdWnd.Group4.OffsetX_EditBox");
    OffsetY_EditBox = GetEditBoxHandle("PVBuilderCmdWnd.Group4.OffsetY_EditBox");
    OffsetZ_EditBox = GetEditBoxHandle("PVBuilderCmdWnd.Group4.OffsetZ_EditBox");
    Pitch_EditBox = GetEditBoxHandle("PVBuilderCmdWnd.Group4.Pitch_EditBox");
    Yaw_EditBox = GetEditBoxHandle("PVBuilderCmdWnd.Group4.Yaw_EditBox");
    Roll_EditBox = GetEditBoxHandle("PVBuilderCmdWnd.Group4.Roll_EditBox");
    OffsetX_EditBox.SetString("0");
    OffsetY_EditBox.SetString("0");
    OffsetZ_EditBox.SetString("0");
    Pitch_EditBox.SetString("0");
    Yaw_EditBox.SetString("0");
    Roll_EditBox.SetString("0");
    Speed_EditBox = GetEditBoxHandle("PVBuilderCmdWnd.Group4.Speed_EditBox");
    Speed_EditBox.SetString("10");
    TelX_EditBox = GetEditBoxHandle("PVBuilderCmdWnd.Group4.TelX_EditBox");
    TelY_EditBox = GetEditBoxHandle("PVBuilderCmdWnd.Group4.TelY_EditBox");
    TelZ_EditBox = GetEditBoxHandle("PVBuilderCmdWnd.Group4.TelZ_EditBox");
    TelX_EditBox.SetString("-114357");
    TelY_EditBox.SetString("252750");
    TelZ_EditBox.SetString("-1545");
    Player_EditBox = GetEditBoxHandle("PVBuilderCmdWnd.Group4.Player_EditBox");
    Player_EditBox.SetString("1");
    sliderSetTime = GetSliderCtrlHandle("PVBuilderCmdWnd.Group4.sliderSetTime");
    txtSetTime = GetTextBoxHandle("PVBuilderCmdWnd.Group4.txtSetTime");
    checkBoxSetTime = GetCheckBoxHandle("PVBuilderCmdWnd.Group4.checkBoxSetTime");
    pv_button = GetButtonHandle("PVBuilderCmdWnd.Group5.pv_button");
    nv_button = GetButtonHandle("PVBuilderCmdWnd.Group5.nv_button");
    sv_button = GetButtonHandle("PVBuilderCmdWnd.Group5.sv_button");
    sc_button = GetButtonHandle("PVBuilderCmdWnd.Group5.sc_button");
    Search_Button = GetButtonHandle("PVBuilderCmdWnd.Group5.search_button");
    minimap_button = GetButtonHandle("PVBuilderCmdWnd.Group5.minimap_button");
    ExecuteCommand("///settime time=12");
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
            // End:0x1CE
            break;
        // End:0x66
        case 1:
            ExecuteCommand("///armorgrp_reload");
            // End:0x1CE
            break;
        // End:0x89
        case 2:
            ExecuteCommand("///weapongrp_reload");
            // End:0x1CE
            break;
        // End:0xAB
        case 3:
            ExecuteCommand("///skillgrp_reload");
            // End:0x1CE
            break;
        // End:0xCB
        case 4:
            ExecuteCommand("///npcgrp_reload");
            // End:0x1CE
            break;
        // End:0xEE
        case 5:
            ExecuteCommand("///hairexgrp_reload");
            // End:0x1CE
            break;
        // End:0x111
        case 6:
            ExecuteCommand("///faceexgrp_reload");
            // End:0x1CE
            break;
        // End:0x132
        case 7:
            ExecuteCommand("///chargrp_reload");
            // End:0x1CE
            break;
        // End:0x13A
        case 8:
            // End:0x1CE
            break;
        // End:0x154
        case 9:
            ExecuteCommand("///reloade");
            // End:0x1CE
            break;
        // End:0x16F
        case 10:
            ExecuteCommand("///reloadse");
            // End:0x1CE
            break;
        // End:0x18B
        case 11:
            ExecuteCommand("///reloadnpc");
            // End:0x1CE
            break;
        // End:0x1AB
        case 12:
            ExecuteCommand("///reloadmonster");
            // End:0x1CE
            break;
        // End:0x1CB
        case 13:
            ExecuteCommand("///reloadwarrior");
            // End:0x1CE
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickRefreshButton()
{
    local string OffsetX, OffsetY, offsetz, Pitch, Yaw, Roll,
	    ride_id;

    ride_id = RideId_EditBox.GetString();
    OffsetX = OffsetX_EditBox.GetString();
    OffsetY = OffsetY_EditBox.GetString();
    offsetz = OffsetZ_EditBox.GetString();
    Pitch = Pitch_EditBox.GetString();
    Yaw = Yaw_EditBox.GetString();
    Roll = Roll_EditBox.GetString();
    ExecuteCommand((((((((((((("///ride id=" $ ride_id) @ "x=") $ OffsetX) @ "y=") $ OffsetY) @ "z=") $ offsetz) @ "pitch=") $ Pitch) @ "yaw=") $ Yaw) @ "roll=") $ Roll);
    return;
}

function OnClickButton(string a_ButtonID)
{
    switch(a_ButtonID)
    {
        // End:0x22
        case "Reload_button":
            OnClickReloadButton();
            // End:0x587
            break;
        // End:0x3E
        case "Refresh_button":
            OnClickRefreshButton();
            // End:0x587
            break;
        // End:0x6B
        case "collision_button":
            ExecuteCommand("///show radii");
            // End:0x587
            break;
        // End:0x95
        case "nameTag_button":
            ExecuteCommand("///show name");
            // End:0x587
            break;
        // End:0xBA
        case "stat_button":
            ExecuteCommand("///stat l2");
            // End:0x587
            break;
        // End:0x147
        case "rmode_button":
            // End:0x118
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
            // End:0x587
            break;
        // End:0x18A
        case "bonename_button":
            ExecuteCommand("///rend bone");
            ExecuteCommand("///rend bonename");
            // End:0x587
            break;
        // End:0x1AC
        case "option_button":
            ExecuteCommand("///ow");
            // End:0x587
            break;
        // End:0x243
        case "AVE_button":
            // End:0x214
            if(AVE_button.GetButtonName() == "Show")
            {
                ExecuteCommand("///aa type=" @ AveId_EditBox.GetString());
                AVE_button.SetNameText("Hide");
                // End:0x587
                break;                
            }
            else
            {
                ExecuteCommand("///aa type=none");
                AVE_button.SetNameText("Show");
                // End:0x587
                break;
            }
        // End:0x27C
        case "Effect_button":
            ExecuteCommand("///se name=" $ Effect_EditBox.GetString());
            // End:0x587
            break;
        // End:0x310
        case "Ride_button":
            // End:0x2E7
            if(Ride_button.GetButtonName() == "Ride")
            {
                ExecuteCommand("///ride id=" @ RideId_EditBox.GetString());
                Ride_button.SetNameText("Unride");
                // End:0x587
                break;                
            }
            else
            {
                ExecuteCommand("///unride");
                Ride_button.SetNameText("Ride");
                // End:0x587
                break;
            }
        // End:0x38F
        case "ghost_button":
            // End:0x367
            if(ghost_button.GetButtonName() == "Ghost")
            {
                ExecuteCommand("///ghost");
                ghost_button.SetNameText("Walk");
                // End:0x587
                break;                
            }
            else
            {
                ExecuteCommand("///walk");
                ghost_button.SetNameText("Ghost");
                // End:0x587
                break;
            }
        // End:0x3BB
        case "search_button":
            ExecuteCommand("///searchobject");
            // End:0x587
            break;
        // End:0x3EE
        case "minimap_button":
            ExecuteCommand("///sw name=minimapwnd");
            // End:0x587
            break;
        // End:0x41F
        case "clone_button":
            ExecuteCommand("///spawnpc copy num=1");
            // End:0x587
            break;
        // End:0x43D
        case "pv_button":
            ExecuteCommand("///pv");
            // End:0x587
            break;
        // End:0x45B
        case "nv_button":
            ExecuteCommand("///nv");
            // End:0x587
            break;
        // End:0x479
        case "sv_button":
            ExecuteCommand("///sv");
            // End:0x587
            break;
        // End:0x498
        case "sc_button":
            ExecuteCommand("///sce");
            // End:0x587
            break;
        // End:0x4D2
        case "SetSpeed_button":
            ExecuteCommand("///gmspeed" @ Speed_EditBox.GetString());
            // End:0x587
            break;
        // End:0x53E
        case "Teleport_button":
            ExecuteCommand((((("///teleport x=" @ TelX_EditBox.GetString()) @ "y=") @ TelY_EditBox.GetString()) @ "z=") @ TelZ_EditBox.GetString());
            // End:0x587
            break;
        // End:0x584
        case "playermove_button":
            ExecuteCommand("///playermove index=" @ Player_EditBox.GetString());
            // End:0x587
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
        // End:0x10E
        case "Location_ComboBox":
            switch(IndexID)
            {
                // End:0x70
                case 0:
                    TelX_EditBox.SetString("-114357");
                    TelY_EditBox.SetString("252750");
                    TelZ_EditBox.SetString("-1545");
                    // End:0x10B
                    break;
                // End:0xBB
                case 1:
                    TelX_EditBox.SetString("-14403");
                    TelY_EditBox.SetString("123296");
                    TelZ_EditBox.SetString("-3122");
                    // End:0x10B
                    break;
                // End:0x108
                case 2:
                    TelX_EditBox.SetString("-11256");
                    TelY_EditBox.SetString("-182506");
                    TelZ_EditBox.SetString("-4996");
                    // End:0x10B
                    break;
                // End:0xFFFF
                default:
                    break;
            }
            // End:0x111
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
    m_WindowName="PVBuilderCmdWnd"
}