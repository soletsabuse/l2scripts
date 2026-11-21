class ViewPortWndEffect extends ViewPortWndBase;

function OnLoad()
{
    super.OnLoad();
    m_ObjectViewport.SetNPCInfo(19671);
    m_ObjectViewport.SetUISound(true);
    m_ObjectViewport.SpawnNPC();
    return;
}
