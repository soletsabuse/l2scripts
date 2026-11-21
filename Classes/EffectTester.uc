class EffectTester extends L2UIGFxScriptNoneContainer;

function OnRegisterEvent()
{
    RegisterEvent(19);
    return;
}

function OnLoad()
{
    SetClosingOnESC();
    AddState("GAMINGSTATE");
    return;
}

function OnEvent(int Id, string param)
{
    ShowWindow("EffectTester");
    return;
}

function OnFlashLoaded()
{
    RegisterDelegateHandler(3);
    return;
}
