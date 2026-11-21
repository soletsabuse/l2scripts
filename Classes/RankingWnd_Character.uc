class RankingWnd_Character extends UICommonAPI;

function OnClickButton(string strID)
{
    RankingWnd(GetScript("RankingWnd")).OnClickButton(strID);
    return;
}

function OnComboBoxItemSelected(string strID, int IndexID)
{
    RankingWnd(GetScript("RankingWnd")).OnComboBoxItemSelected(strID, IndexID);
    return;
}

function OnClickListCtrlRecord(string ListCtrlID)
{
    RankingWnd(GetScript("RankingWnd")).OnClickListCtrlRecord(ListCtrlID);
    return;
}

function OnCompleteEditBox(string EditBoxID)
{
    RankingWnd(GetScript("RankingWnd")).OnCompleteEditBox(EditBoxID);
    return;
}
