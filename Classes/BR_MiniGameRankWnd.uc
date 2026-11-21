class BR_MiniGameRankWnd extends UICommonAPI;

const TIMER_ID1 = 2001;
const TIMER_ID2 = 2002;
const TIMER_ID3 = 2003;
const TIMER_ID4 = 2004;

var WindowHandle Me;
var ListCtrlHandle RankingList;
var TextBoxHandle TextBoxRank;
var TextBoxHandle TextBoxMsg;
var int MyBestScore;

function OnRegisterEvent()
{
    RegisterEvent(9120);
    RegisterEvent(9121);
    return;
}

function OnLoad()
{
    Initialize();
    return;
}

function Initialize()
{
    // End:0xBC
    if(1 == 0)
    {
        Me = GetHandle("BR_MiniGameRankWnd");
        RankingList = ListCtrlHandle(GetHandle("BR_MiniGameRankWnd.RankingList"));
        TextBoxRank = TextBoxHandle(GetHandle("BR_MiniGameRankWnd.TextBoxRank"));
        TextBoxMsg = TextBoxHandle(GetHandle("BR_MiniGameRankWnd.TextBoxMsg"));        
    }
    else
    {
        Me = GetWindowHandle("BR_MiniGameRankWnd");
        RankingList = GetListCtrlHandle("BR_MiniGameRankWnd.RankingList");
        TextBoxRank = GetTextBoxHandle("BR_MiniGameRankWnd.TextBoxRank");
        TextBoxMsg = GetTextBoxHandle("BR_MiniGameRankWnd.TextBoxMsg");
    }
    Me.SetWindowTitle((GetSystemString(1730) $ " ") $ GetSystemString(1320));
    MyBestScore = 0;
    return;
}

function OnEvent(int Event_ID, string param)
{
    local int MyRanking, myScore, LastScore, Ranking;
    local string charName;
    local int Score;

    switch(Event_ID)
    {
        // End:0x85
        case 9120:
            RankingList.DeleteAllItem();
            ParseInt(param, "MyRanking", MyRanking);
            ParseInt(param, "MyScore", myScore);
            ParseInt(param, "LastScore", LastScore);
            SetMyRank(MyRanking, myScore, LastScore);
            // End:0xF2
            break;
        // End:0xEF
        case 9121:
            ParseInt(param, "Ranking", Ranking);
            ParseString(param, "CharName", charName);
            ParseInt(param, "Score", Score);
            ShowRank(Ranking, charName, Score);
            // End:0xF2
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function SetMyRank(int MyRanking, int myScore, int LastScore)
{
    // End:0x8D
    if(MyRanking == 0)
    {
        TextBoxRank.SetText(((((GetSystemString(5058) $ ": ") $ GetSystemString(1374)) $ " (") $ MakeFullSystemMsg(GetSystemMessage(6036), string(LastScore), "")) $ ")");
        TextBoxMsg.SetText(MakeFullSystemMsg(GetSystemMessage(6033), "100", "1000"));        
    }
    else
    {
        TextBoxRank.SetText((((((((GetSystemString(5058) $ ": ") $ string(MyRanking)) $ GetSystemString(1375)) $ "   ") $ GetSystemString(5059)) $ " : ") $ string(myScore)) $ GetSystemString(1442));
        TextBoxMsg.SetText(GetSystemMessage(6035));
        // End:0x127
        if(MyBestScore == 0)
        {
            MyBestScore = myScore;            
        }
        else
        {
            // End:0x157
            if(myScore > MyBestScore)
            {
                Me.SetTimer(2001, 200);
                MyBestScore = myScore;
            }
        }
    }
    return;
}

function ShowRank(int Ranking, string charName, int Score)
{
    local LVDataRecord Record;
    local LVData data1, data2, data3;
    local Color RankColor, BestColor;

    RankColor.R = 130;
    RankColor.G = 130;
    RankColor.B = 130;
    data1.bUseTextColor = true;
    data1.TextColor = RankColor;
    // End:0xB7
    if(Ranking == 1)
    {
        BestColor.R = byte(255);
        BestColor.G = byte(255);
        BestColor.B = 51;
        data2.bUseTextColor = true;
        data3.bUseTextColor = true;
        data2.TextColor = BestColor;
        data3.TextColor = BestColor;        
    }
    else
    {
        // End:0x12B
        if(Ranking == 2)
        {
            BestColor.R = byte(255);
            BestColor.G = byte(255);
            BestColor.B = 153;
            data2.bUseTextColor = true;
            data3.bUseTextColor = true;
            data2.TextColor = BestColor;
            data3.TextColor = BestColor;            
        }
        else
        {
            // End:0x198
            if(Ranking == 3)
            {
                BestColor.R = 204;
                BestColor.G = 204;
                BestColor.B = 120;
                data2.bUseTextColor = true;
                data3.bUseTextColor = true;
                data2.TextColor = BestColor;
                data3.TextColor = BestColor;
            }
        }
    }
    data1.szData = string(Ranking);
    data2.szData = charName;
    data3.szData = string(Score);
    Record.LVDataList.Length = 3;
    Record.LVDataList[0] = data1;
    Record.LVDataList[1] = data2;
    Record.LVDataList[2] = data3;
    RankingList.InsertRecord(Record);
    return;
}

function OnTimer(int TimerID)
{
    // End:0x4B
    if(TimerID == 2001)
    {
        TextBoxRank.HideWindow();
        Me.KillTimer(2001);
        Me.SetTimer(2002, 200);        
    }
    else
    {
        // End:0x96
        if(TimerID == 2002)
        {
            TextBoxRank.ShowWindow();
            Me.KillTimer(2002);
            Me.SetTimer(2003, 200);            
        }
        else
        {
            // End:0xE1
            if(TimerID == 2003)
            {
                TextBoxRank.HideWindow();
                Me.KillTimer(2003);
                Me.SetTimer(2004, 200);                
            }
            else
            {
                // End:0x113
                if(TimerID == 2004)
                {
                    TextBoxRank.ShowWindow();
                    Me.KillTimer(2004);
                }
            }
        }
    }
    return;
}
