VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "a4x1_CDPMessageGenerator"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private id_ As Long

Public Property Get Id() As Long
    Id = id_
End Property

'TargetDomain*******************************************************************
'pageDomain�̒ʒm��L���ɂ���B
Public Function PageEnable() As String
    id_ = id_ + 1
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""Page.enable""}"
    PageEnable = message
End Function

Public Function SetDiscoverTargets() As String
    id_ = id_ + 1
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""Target.setDiscoverTargets""," & _
                      """params"": {""discover"": true}}"
    SetDiscoverTargets = message
End Function

Public Function AttachToTarget(targetId As String) As String
    id_ = id_ + 1
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""Target.attachToTarget""," & _
                      """params"": {""targetId"": """ & targetId & """}}"
    AttachToTarget = message
End Function

Public Function ActivateTarget(targetId As String) As String
    id_ = id_ + 1
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""Target.activateTarget""," & _
                      """params"": {""targetId"": """ & targetId & """}}"
    ActivateTarget = message
End Function

Public Function DetachFromTarget(targetId As String) As String
    id_ = id_ + 1
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""Target.detachFromTarget""," & _
                      """params"": {""targetId"": """ & targetId & """}}"
    DetachFromTarget = message
End Function

Public Function TargetClose(targetId As String) As String
    id_ = id_ + 1
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""Target.closeTarget""," & _
                      """params"": {""targetId"": """ & targetId & """}}"
    TargetClose = message
End Function
'���p�\�ȃ^�[�Q�b�g�̃��X�g���擾����B
Public Function GetTargets() As String
    id_ = id_ + 1
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""Target.getTargets""}"
    GetTargets = message
End Function
'*******************************************************************


'BrowserDomain*******************************************************************
Public Function SessionClose() As String
    id_ = id_ + 1
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""Browser.close""}"
    SessionClose = message
End Function
'*******************************************************************

'PageDomain*******************************************************************
Public Function URLOpen(URL As String) As String
    id_ = id_ + 1
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""Page.navigate""," & _
                      """params"": {""url"": """ & URL & """}}"
    URLOpen = message
End Function

Public Function HandleJavaScriptDialog() As String
    id_ = id_ + 1
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""Page.handleJavaScriptDialog""," & _
                     """params"": {""accept"": true}}"
    HandleJavaScriptDialog = message
End Function

Public Function GetFrameTree() As String
    id_ = id_ + 1
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""Page.getFrameTree""}"
    GetFrameTree = message
End Function

Public Function CreateIsolatedFrameWorld(FrameId As String) As String
    id_ = id_ + 1
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""Page.createIsolatedWorld""," & _
                     """params"": {""frameId"": """ & FrameId & """,""grantUniveralAccess"": true}}"
    CreateIsolatedFrameWorld = message
End Function

'*******************************************************************
'Input Domain*******************************************************************
'�L�[�C�x���g���y�[�W�Ƀf�B�X�p�b�`����BkeyDown , keyUp, rawKeyDown, char�̂����ꂩ�B
Public Function DispatchKeyEvent_DOMKeyCode(eventType As String, code As String) As String
    id_ = id_ + 1
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""Input.dispatchKeyEvent""," & _
                      """params"": {""type"":  """ & eventType & """,""code"": """ & code & """}}"
    DispatchKeyEvent_DOMKeyCode = message
    
'    windowsVirtualKeyCode
End Function

'�}�E�X�C�x���g��xy���W�Ƀf�B�X�p�b�`����BmousePressed, mouseReleased, mouseMoved, mouseWheel�̂����ꂩ�B
Public Function DispatchMouseEvent(eventType As String, x As Long, y As Long, _
                                                        button As String, clickCount As Long, _
                                                        Optional modifiers As Long = 0, _
                                                        Optional deltaX As Long = 0, Optional deltaY As Long = 0) As String
    id_ = id_ + 1
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""Input.dispatchMouseEvent""," & _
                      """params"": {""type"":  """ & eventType & """,""x"": " & x & ",""y"": " & y & "," & _
                                            """button"": """ & button & """,""clickCount"": " & clickCount
                                            'none, left, middle, right, back, forward�̂����ꂩ
                                            
    'Alt=1, Ctrl=2, Meta/Command=4, Shift=8
    If modifiers <> 0 Then
        message = message & ",""modifiers"": " & modifiers
    End If
    
    If deltaX <> 0 Or deltaY <> 0 Then
        message = message & ",""deltaX"": " & deltaX & ",""deltaY"": " & deltaY
    End If
    
    message = message & "}}"
    DispatchMouseEvent = message
End Function
'*******************************************************************
'DOM Domain*******************************************************************
'Dom�̗L����
Public Function DOM_Enable()
    id_ = id_ + 1
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""DOM.enable""}"
    DOM_Enable = message
End Function

'�w�肳�ꂽ�v�f�Ƀt�H�[�J�X�𓖂Ă�B
Public Function Focus(ObjectId As String) As String
    id_ = id_ + 1
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""DOM.focus""," & _
                      """params"": {""objectId"":  """ & ObjectId & """}}"
    Focus = message
End Function

'DocumentObject��NodeId���擾
Public Function GetDocumentID() As String
    id_ = id_ + 1
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""DOM.getDocument""," & _
                     """params"": {""depth"": " & 1 & "}}"
    GetDocumentID = message
End Function

'CSS�Z���N�^�ɂ��Node�擾
Public Function querySelector(Selector As String, Optional nodeId As Long = 1) As String
    id_ = id_ + 1
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""DOM.querySelector""," & _
                      """params"": {""nodeId"":  " & nodeId & ",""selector"": """ & Selector & """}}"
    querySelector = message
End Function

'objectId����nodeId�擾
Public Function RequestNode(ObjectId As String) As String
    id_ = id_ + 1
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""DOM.requestNode""," & _
                      """params"": {""objectId"":  """ & ObjectId & """}}"
    RequestNode = message
End Function

'nodeId����objectId�擾
Public Function ResolveNode(nodeId As Long)
    id_ = id_ + 1
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""DOM.resolveNode""," & _
                      """params"": {""nodeId"":  " & nodeId & "}}"
    ResolveNode = message
End Function
'id�Ŏw�肳�ꂽ�m�[�h�̑��������擾
Public Function GetAttributes(nodeId As Long)
    id_ = id_ + 1
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""DOM.getAttributes""," & _
                      """params"":{""nodeId"":  " & nodeId & "}}"
    GetAttributes = message
End Function

'id �Ŏw�肳�ꂽ�m�[�h�������q
Public Function DescribeNode(Id As Variant) As Variant
    id_ = id_ + 1
    Dim message As String
    If IsNumeric(Id) Then
        message = "{""id"": " & id_ & ",""method"": ""DOM.describeNode""," & _
                          """params"": {""nodeId"":  " & Id & ",""depth"": 1,""pierce"": false}}"
    Else
        message = "{""id"": " & id_ & ",""method"": ""DOM.describeNode""," & _
                         """params"": {""objectId"":  """ & Id & """,""depth"": 1,""pierce"": false}}"
    End If
    DescribeNode = message
End Function

Public Function RequestChildNodes() As String
    id_ = id_ + 1
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""DOM.RequestChildNodes""," & _
                      """params"": {""nodeId"":  " & id_ & ",""depth"":  -1}}"
    RequestChildNodes = message
End Function

'�w�肳�ꂽ�v�f�Ƀt�H�[�J�X�𓖂Ă�B
Public Function GetBoxModel(ObjectId As String) As String
    id_ = id_ + 1
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""DOM.getBoxModel""," & _
                      """params"": {""objectId"":  """ & ObjectId & """}}"
    GetBoxModel = message
End Function

'�t�@�C���o�^�C���v�b�g�{�b�N�X�փt�@�C��Path�o�^
Public Function SetFileInputFiles(ObjectId As Variant, files As String) As String
    id_ = id_ + 1
    files = "[""" & files & """]"
    
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""DOM.setFileInputFiles""," & _
                      """params"": " & _
                     "{""files"": " & files & ",""objectId"": """ & ObjectId & """}}"
    
    SetFileInputFiles = message
End Function

'RunTime Domain*******************************************************************
Public Function RunTime_Enable()
    id_ = id_ + 1
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""Runtime.enable""}"
    RunTime_Enable = message
End Function
Public Function JavaScritpEvaluate(script As String)
    id_ = id_ + 1
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""Runtime.evaluate""," & _
                      """params"": {""expression"": """ & script & """,""returnByValue"": false}}"
    JavaScritpEvaluate = message
End Function

Public Function CallJavascriptFunction(funcDeclear As String, ObjectId As Variant, argments As Variant)
    id_ = id_ + 1
    Dim JavaScriptObjectArgs As String
    
    If argments = "true" Or argments = "false" Then
        JavaScriptObjectArgs = "[{""value"": " & argments & "}]"
    Else
        JavaScriptObjectArgs = "[{""value"": """ & argments & """}]"
    End If
    
    Dim message As String
    message = "{""id"": " & id_ & ",""method"": ""Runtime.callFunctionOn""," & _
                      """params"": " & _
                     "{""functionDeclaration"": """ & funcDeclear & """,""arguments"": " & JavaScriptObjectArgs
    If IsNumeric(ObjectId) Then
        message = message & ",""executionContextId"": " & ObjectId & "}}"
    Else
        message = message & ",""objectId"": """ & ObjectId & """}}"
    End If
    CallJavascriptFunction = message
End Function
'*******************************************************************