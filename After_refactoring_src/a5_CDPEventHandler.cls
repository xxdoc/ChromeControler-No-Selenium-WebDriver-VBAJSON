VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "a5_CDPEventHandler"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit
Private Declare PtrSafe Sub Sleep Lib "kernel32" (ByVal ms As LongPtr)

Private Json_ As a2_JSONHandler
Private basicInfo_ As a3_BasicInfos

'�_�C�A���O���
Public DialogInfoDic As Object
Public PageInfos As Collection
Public IframeInfos As Collection

Public IsCurrentTargetScheduledNavigation As Boolean
Public IsCurrentTargetStartedLoading As Boolean
Public IsCurrentTargetClearedScheduledNavigation As Boolean
Public IsCurrentTargetNavigated As Boolean

Public IsIsolatedFrameScheduledNavigation As Boolean
Public IsIsolatedFrameStartedLoading As Boolean
Public IsIsolatedFrameClearedScheduledNavigation As Boolean
Public IsIsolatedFrameNavigated As Boolean

Public IsCurrentContextIdDestroyed As Boolean



Public Sub Init(Json As a2_JSONHandler, basicInfo As a3_BasicInfos)
    Set Json_ = Json
    Set basicInfo_ = basicInfo
    
    Set DialogInfoDic = CreateObject("Scripting.Dictionary")
    InitializeDialogInfo
    Set PageInfos = New Collection
    Set IframeInfos = New Collection
End Sub

'�e��C�x���g�������ɏ����擾����
Public Sub GetInfo(EventInfo As String)
    Dim eventName As String
    eventName = Json_.GetValue(EventInfo, "method")
    
    If InStr(eventName, "frame") > 0 Then
        Dim Id As String
        If InStr(eventName, "Navigated") = 0 Then
            Id = Json_.GetValue(EventInfo, "params", "frameId")
        Else
            Id = Json_.GetValue(EventInfo, "params", "frame", "id")
        End If
        Dim isCurrentTarget As Boolean
        isCurrentTarget = (Id = basicInfo_.targetId)
        Dim isIsolatedFrameId
        isIsolatedFrameId = (Id = basicInfo_.IsolatedFrameId)
    End If
    
    Select Case eventName
        Case "Page.javascriptDialogOpening"
            SetDialogInfo EventInfo
            Debug.Print "����DialogOpening"
        Case "Page.javascriptDialogClosed"
            InitializeDialogInfo
            Debug.Print "����DialogClosed"
            
        Case "Target.targetCreated"
            AddTargetInfo EventInfo
        Case "Target.targetInfoChanged"
            ChangeTargetInfo EventInfo
        Case "Target.targetDestroyed"
            RemoveTargetInfo EventInfo
            
        Case "Page.frameScheduledNavigation" '�񐄏��ƂȂ��Ă��邪���ꂪ�Ԃ��Ă���B
            If InStr(EventInfo, "anchorClick") > 0 Then
                If isCurrentTarget Then IsCurrentTargetScheduledNavigation = True
                If isIsolatedFrameId Then
                    IsIsolatedFrameScheduledNavigation = True
                    Debug.Print "����IsolatedFrameScheduledNavigation"
                End If
            End If
        Case "Page.frameStartedLoading"
            If isCurrentTarget Then IsCurrentTargetStartedLoading = True
            If isIsolatedFrameId Then
                IsIsolatedFrameStartedLoading = True
                Sleep 1000
            End If
'        Case "Page.frameClearedScheduledNavigation" '�񐄏��ƂȂ��Ă��邪���ꂪ�Ԃ��Ă���B
'            If isCurrentTarget Then IsCurrentTargetClearedScheduledNavigation = True
'            If isIsolatedFrameId Then IsIsolatedFrameClearedScheduledNavigation = True
        Case "Page.frameNavigated"
            If isCurrentTarget Then IsCurrentTargetNavigated = True
            If isIsolatedFrameId Then
                IsIsolatedFrameNavigated = True
                Debug.Print "����IsolatedFrameNavigated"
            End If
        Case "Runtime.executionContextDestroyed"
            Dim contextId As Long
            contextId = Json_.GetValue(EventInfo, "params", "executionContextId")
            If contextId = basicInfo_.ExecutionContextId Then
                IsCurrentContextIdDestroyed = True
                Debug.Print "����IsCurrentContextIdDestroyed"
            End If
    End Select
End Sub
'�A���[�g�_�C�A���O�o�����ɏ����擾
Private Sub SetDialogInfo(ByVal EventInfo As String)
    DialogInfoDic("IsExistDialog") = True
    DialogInfoDic("DialogMessage") = Json_.GetValue(EventInfo, "params", "message")
    DialogInfoDic("DialogType") = Json_.GetValue(EventInfo, "params", "type")
    If Json_.GetValue(EventInfo, "params", "hasBrowserHandler") = "True" Then
        DialogInfoDic("HasBrowserHandler") = True
    Else
        DialogInfoDic("HasBrowserHandler") = False
    End If
    DialogInfoDic("DefaultPrompt") = Json_.GetValue(EventInfo, "params", "defaultPrompt")
End Sub
'�A���[�g�_�C�A���O�o�����ɏ����i�[���鎫���̏�����
Private Sub InitializeDialogInfo()
    DialogInfoDic.RemoveAll
    DialogInfoDic.add "IsExistDialog", False
    DialogInfoDic.add "DialogMessage", ""
    DialogInfoDic.add "DialogType", ""
    DialogInfoDic.add "HasBrowserHandler", False
    DialogInfoDic.add "DefaultPrompt", ""
End Sub

'Target��Type�ɂ�褂��ꂼ��R���N�V�����ɏ����擾����
Private Sub AddTargetInfo(ByVal EventInfo As String)
    Dim tempdic As Object
    Set tempdic = CreateObject("Scripting.Dictionary")
    tempdic.add "targetId", Json_.GetValue(EventInfo, "params", "targetInfo", "targetId")
    tempdic.add "title", Json_.GetValue(EventInfo, "params", "targetInfo", "title")
    tempdic.add "url", Json_.GetValue(EventInfo, "params", "targetInfo", "url")
    tempdic.add "browserContextId", Json_.GetValue(EventInfo, "params", "targetInfo", "browserContextId")
    
    Dim targetType As String
    targetType = Json_.GetValue(EventInfo, "params", "targetInfo", "type")
    Select Case targetType
      Case "page"
        AddInfoOf PageInfos, tempdic, EventInfo
      Case "iframe"
        AddInfoOf IframeInfos, tempdic, EventInfo
    End Select
End Sub
'Chrome���Target���ǉ����ꂽ��A�eTargetType�̏����Ǘ�����Collection�ɂ��̏���Dictionary�Ƃ��Ă܂Ƃ߂Ēǉ�����B
Private Sub AddInfoOf(infos As Collection, tempdic As Object, _
                                    ByVal EventInfo As String)
                                        
    '�{��targetInfoChanged�ŗ���ׂ����e��targetCreated�ŗ���P�[�X����B
    'SetDiscoverTarget�g�p����Ɗ��ɊJ����Ă���Page��Create�����͗l
    Dim i As Long
    For i = 1 To infos.Count
        If infos(i)("targetId") = tempdic("targetId") Then
            infos(i)("title") = tempdic("targetId")
            infos(i)("url") = tempdic("url")
            infos(i)("browserContextId") = tempdic("browserContextId")
            Exit Sub
        End If
    Next
    infos.add tempdic
End Sub

'Chrome���Page(�^�u)�̏�񂪕ύX���ꂽ��APage�����Ǘ�����Collection���̊Y��Page�̏���ύX����B
Private Sub ChangeTargetInfo(ByVal EventInfo As String)
    Dim targetType As String
    targetType = Json_.GetValue(EventInfo, "params", "targetInfo", "type")
    
    Select Case targetType
      Case "page"
        ChangeInfoOf PageInfos, EventInfo
      Case "iframe"
        ChangeInfoOf IframeInfos, EventInfo
    End Select
End Sub
Private Sub ChangeInfoOf(infos As Collection, _
                                        ByVal EventInfo As String)
    Dim targetId As String
    targetId = Json_.GetValue(EventInfo, "params", "targetInfo", "targetId")
    Dim info As Variant
    For Each info In infos
        If info("targetId") = targetId Then
            info("title") = Json_.GetValue(EventInfo, "params", "targetInfo", "title")
            info("url") = Json_.GetValue(EventInfo, "params", "targetInfo", "url")
            info("browserContextId") = Json_.GetValue(EventInfo, "params", "targetInfo", "browserContextId")
        End If
    Next
End Sub

'Chrome���Page(�^�u)���폜���ꂽ��APage�����Ǘ�����Collection���炻�̏����폜����B
Private Sub RemoveTargetInfo(ByVal EventInfo As String)
    Dim targetType As String
    targetType = Json_.GetValue(EventInfo, "params", "targetInfo", "type")
    
    Select Case targetType
      Case "page"
        RemoveInfoOf PageInfos, EventInfo
      Case "iframe"
        RemoveInfoOf IframeInfos, EventInfo
    End Select
End Sub
Private Sub RemoveInfoOf(infos As Collection, _
                                        ByVal EventInfo As String)
    Dim targetId As String
    targetId = Json_.GetValue(EventInfo, "params", "targetInfo", "targetId")
    
    Dim i As Long
    For i = 1 To infos.Count
        If infos(i)("targetId") = targetId Then
            infos.Remove i
        End If
    Next
End Sub

Public Sub ForDebug_ShowtargetInfo()
    Dim i  As Long
    Debug.Print "PageInfos��==============="
    For i = 1 To PageInfos.Count
        Debug.Print i & "�F" & PageInfos(i)("targetId")
    Next
    Debug.Print "IframeInfos��==============="
    For i = 1 To IframeInfos.Count
        Debug.Print i & "�F" & IframeInfos(i)("targetId")
    Next
    Debug.Print "========================"
End Sub