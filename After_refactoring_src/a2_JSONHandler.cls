VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "a2_JSONHandler"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
Option Explicit

Private html As Object
Private Sub Class_Initialize()
    Set html = CreateObject("htmlfile")
    html.write "<meta http-equiv='X-UA-Compatible' content='IE=edge' />"

    'URL�G���R�[�f�B���O
    html.write _
        "<script>" & vbCrLf & _
            "document.EncodeURL = " & vbCrLf & _
            "function(s){" & vbCrLf & _
            "return encodeURI(s);" & vbCrLf & _
            "}" & vbCrLf & _
        "</script>"
    
    html.write _
        "<script>" & vbCrLf & _
            "document.DecodeURL = " & vbCrLf & _
            "function(s){" & vbCrLf & _
            "return decodeURI(s);" & vbCrLf & _
            "}" & vbCrLf & _
        "</script>"
'JSON����
'============================
    '�z�񂩂�I�u�W�F�N�g���o��
    html.write _
        "<script>" & vbCrLf & _
            "document.getObjectFromArrayBySetIndex = " & vbCrLf & _
            "function(targetJson,index){" & vbCrLf & _
            "var vals = JSON.parse(targetJson);" & vbCrLf & _
            "return JSON.stringify(vals[index]);" & vbCrLf & _
            "}" & vbCrLf & _
        "</script>"
    '�I�u�W�F�N�g����I�u�W�F�N�g�����o��
    html.write _
        "<script>" & vbCrLf & _
            "document.getObjectFromObjectBySetKey = " & vbCrLf & _
            "function(targetJson,key){" & vbCrLf & _
            "var vals = JSON.parse(targetJson);" & vbCrLf & _
            "return JSON.stringify(vals[key]);" & vbCrLf & _
            "}" & vbCrLf & _
        "</script>"
    '�z�񂩂�l�����o��
    html.write _
        "<script>" & vbCrLf & _
            "document.getValueFromArrayBySetIndex = " & vbCrLf & _
            "function(targetJson,index){" & vbCrLf & _
            "var vals = JSON.parse(targetJson);" & vbCrLf & _
            "return vals[index];" & vbCrLf & _
            "}" & vbCrLf & _
        "</script>"
    '�I�u�W�F�N�g����l�����o��
    html.write _
        "<script>" & vbCrLf & _
            "document.getValueFromObjectBySetKey = " & vbCrLf & _
            "function(targetJson,key){" & vbCrLf & _
            "var vals = JSON.parse(targetJson);" & vbCrLf & _
            "return vals[key];" & vbCrLf & _
            "}" & vbCrLf & _
        "</script>"
        
    html.write _
        "<script>" & vbCrLf & _
            "document.getJsonLength = " & vbCrLf & _
            "function(targetJson){" & vbCrLf & _
            "var vals = JSON.parse(targetJson);" & vbCrLf & _
            "return vals.length;" & vbCrLf & _
            "}" & vbCrLf & _
        "</script>"
End Sub

Public Function EncodeURL(Json As String) As String
    EncodeURL = html.EncodeURL(Json)
End Function

Public Function DecodeURL(Json As String) As String
    DecodeURL = html.DecodeURL(Json)
End Function

Public Function GetValue(ByVal Json As String, ParamArray argsArray() As Variant) As String
    Dim i As Long
    Dim Result As String
    For i = LBound(argsArray) To UBound(argsArray)
        If Json = "" Then
            GetValue = Result
            Exit Function
        End If
        If i <> UBound(argsArray) Then
            If IsNumeric(argsArray(i)) Then
                Json = html.getObjectFromArrayBySetIndex(Json, argsArray(i))
            Else
                Json = html.getObjectFromObjectBySetKey(Json, argsArray(i))
            End If
        Else
            If IsNumeric(argsArray(i)) Then
                Result = html.getValueFromArrayBySetIndex(Json, argsArray(i))
            Else
                Result = html.getValueFromObjectBySetKey(Json, argsArray(i))
            End If
        End If
    Next
    GetValue = Result
End Function

Public Function GetObject(ByVal Json As String, ParamArray argsArray() As Variant) As String
    Dim i As Long
    Dim Result As String
    For i = LBound(argsArray) To UBound(argsArray)
        If Json = "" Then
            GetObject = Json
            Exit Function
        End If
     
        If IsNumeric(argsArray(i)) Then
            Json = html.getObjectFromArrayBySetIndex(Json, argsArray(i))
        Else
            Json = html.getObjectFromObjectBySetKey(Json, argsArray(i))
        End If
    Next
    GetObject = Json
End Function


Public Function GetJsonLength(Json As String) As Long
    GetJsonLength = html.GetJsonLength(Json)
End Function