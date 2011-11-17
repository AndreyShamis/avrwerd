VERSION 5.00
Object = "{648A5603-2C6E-101B-82B6-000000000014}#1.1#0"; "MSCOMM32.OCX"
Begin VB.Form frmMain 
   Caption         =   "Pomidornica Project"
   ClientHeight    =   7245
   ClientLeft      =   75
   ClientTop       =   375
   ClientWidth     =   10050
   Icon            =   "frmMain.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   7245
   ScaleWidth      =   10050
   StartUpPosition =   3  'Windows Default
   Begin MSCommLib.MSComm MSComm1 
      Left            =   3360
      Top             =   3720
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      DTREnable       =   -1  'True
   End
   Begin VB.CommandButton Command6 
      BackColor       =   &H00FFC0C0&
      Caption         =   "B"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   204
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   9360
      Style           =   1  'Graphical
      TabIndex        =   15
      Top             =   960
      Width           =   375
   End
   Begin VB.CommandButton Command5 
      BackColor       =   &H00C0FFC0&
      Caption         =   "A"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   12
         Charset         =   204
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   315
      Left            =   8880
      Style           =   1  'Graphical
      TabIndex        =   14
      Top             =   960
      Width           =   375
   End
   Begin VB.Timer Timer2 
      Interval        =   200
      Left            =   240
      Top             =   840
   End
   Begin VB.Timer Timer1 
      Interval        =   100
      Left            =   240
      Top             =   1560
   End
   Begin VB.CommandButton Command4 
      Caption         =   "Clear"
      Height          =   255
      Left            =   9000
      TabIndex        =   6
      Top             =   3720
      Width           =   975
   End
   Begin VB.CommandButton Command3 
      Caption         =   "Clear"
      Height          =   255
      Left            =   9000
      TabIndex        =   5
      Top             =   1800
      Width           =   975
   End
   Begin VB.TextBox Text2 
      BackColor       =   &H80000001&
      Height          =   1455
      Left            =   120
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   4
      Top             =   2160
      Width           =   9855
   End
   Begin VB.CommandButton Command2 
      Caption         =   "Command2"
      Height          =   495
      Left            =   3000
      TabIndex        =   3
      Top             =   1080
      Width           =   1575
   End
   Begin VB.TextBox Text1 
      Height          =   3135
      Left            =   120
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Both
      TabIndex        =   2
      Top             =   4080
      Width           =   9855
   End
   Begin VB.CommandButton Command1 
      BackColor       =   &H0000C000&
      Caption         =   "On"
      Height          =   375
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   0
      Top             =   360
      Width           =   975
   End
   Begin MSCommLib.MSComm MSComm12 
      Left            =   6600
      Top             =   3480
      _ExtentX        =   1005
      _ExtentY        =   1005
      _Version        =   393216
      CommPort        =   3
      DTREnable       =   -1  'True
      EOFEnable       =   -1  'True
   End
   Begin VB.Label lvlObduv 
      Alignment       =   2  'Center
      BackColor       =   &H008080FF&
      BorderStyle     =   1  'Fixed Single
      Caption         =   "�����"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   204
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   4800
      TabIndex        =   18
      Top             =   840
      Width           =   1455
   End
   Begin VB.Label lblLightStatus 
      Alignment       =   2  'Center
      BackColor       =   &H008080FF&
      BorderStyle     =   1  'Fixed Single
      Caption         =   "Light"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   204
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   4800
      TabIndex        =   17
      Top             =   120
      Width           =   1455
   End
   Begin VB.Label lblVentilacia 
      Alignment       =   2  'Center
      BackColor       =   &H0080FF80&
      BorderStyle     =   1  'Fixed Single
      Caption         =   "���������"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   204
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   375
      Left            =   4800
      TabIndex        =   16
      Top             =   480
      Width           =   1455
   End
   Begin VB.Label lvlRejimVal 
      Alignment       =   2  'Center
      BackStyle       =   0  'Transparent
      Caption         =   "A"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   204
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      ForeColor       =   &H00FF0000&
      Height          =   255
      Left            =   8760
      TabIndex        =   13
      Top             =   720
      Width           =   615
   End
   Begin VB.Label Label5 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "12/12"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   204
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   9240
      TabIndex        =   12
      Top             =   720
      Width           =   735
   End
   Begin VB.Label Label4 
      BackStyle       =   0  'Transparent
      Caption         =   "�����"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   204
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   7440
      TabIndex        =   11
      Top             =   720
      Width           =   1215
   End
   Begin VB.Label lblLocalTime 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "15:26"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   204
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   8760
      TabIndex        =   10
      Top             =   120
      Width           =   1215
   End
   Begin VB.Label lblDeviceTime 
      Alignment       =   1  'Right Justify
      BackStyle       =   0  'Transparent
      Caption         =   "16:48"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   204
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   8760
      TabIndex        =   9
      Top             =   360
      Width           =   1215
   End
   Begin VB.Label Label3 
      BackStyle       =   0  'Transparent
      Caption         =   "Device time:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   204
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   7440
      TabIndex        =   8
      Top             =   360
      Width           =   1215
   End
   Begin VB.Label Label2 
      BackStyle       =   0  'Transparent
      Caption         =   "Local time:"
      BeginProperty Font 
         Name            =   "MS Sans Serif"
         Size            =   9.75
         Charset         =   204
         Weight          =   700
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   255
      Left            =   7440
      TabIndex        =   7
      Top             =   120
      Width           =   1215
   End
   Begin VB.Label Label1 
      Caption         =   "Label1"
      Height          =   375
      Left            =   1800
      TabIndex        =   1
      Top             =   240
      Width           =   1815
   End
End
Attribute VB_Name = "frmMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Dim ComPortStatus As Boolean

Private Sub Command1_Click()

If ComPortStatus = False Then
    ComPortStatus = True
    MSComm1.PortOpen = True
    Command1.Caption = "Off"
    Command1.BackColor = &HFF&
Else
    ComPortStatus = False
    MSComm1.PortOpen = False
    Command1.Caption = "Off"
    Command1.BackColor = &HFF00&
End If


End Sub

Private Sub Command2_Click()
If ComPortStatus = True Then

While (ComPortStatus)
    DoEvents
    If ComPortStatus = True Then
        MSComm1.Output = "A"
    End If
Wend
    
End If
End Sub

Private Sub Command3_Click()
Text2.Text = ""
End Sub

Private Sub Command4_Click()
Text1.Text = ""
End Sub


Private Sub Text2_Change()
If Len(Text2.Text) Then
    MSComm1.Output = Mid(Text2.Text, Len(Text2.Text))
End If
End Sub

Private Sub Timer1_Timer()
If ComPortStatus = True Then
    Text2.Enabled = True
    Text2.BackColor = &H80000004
Else
    Text2.Enabled = False
    Text2.BackColor = &H80000003
End If
End Sub

Private Sub Timer2_Timer()

Timer2.Enabled = False
If ComPortStatus = True Then
    
    Dim flag As Boolean
    Dim sInput As String
    flag = True
    Text1.Text = vbNewLine & Text1.Text
    While (flag And ComPortStatus)
        DoEvents
        sInput = MSComm1.Output
        If (Len(sInput) > 0) Then
            Text1.Text = sInput & Text1.Text
        Else
            flag = False
        End If
    Wend
    
End If
Timer2.Enabled = True
End Sub

'���������� �� ������ �������� ����, ����� ������� !

'Break - ��������, Boolean, ������/ ������, ������ � ������ ���������� (RunTime). ����������������
'�������� ������ � ����� �� ������ ����� ��������. ������ ������������ � ������������, ����������
'������ Break.
'CDHolding - ��������, Boolean, ������ ������ � ������ ���������� (RunTime). ���������� �������
'�������, ��������� ��������� ����� Carrier Detect (CD). CD - � ���� ������� ����������� �����
'������ ��� ONLINE. CD ����� ��� ���� �������� - Receive Line Signal Detect (RLSD).
'CommEvent - ��������, Integer, ������ ������ � ������ ���������� (RunTime). ���������� ��� �������
'��� ������, � ���������� �������� ��������� ������� OnComm.
'������ ����� ���������� �������� ��� ������� �������/ ������. ��������� ����
'�� ���������������.
'CommID - ��������, Long, ������ ������ � ������ ���������� (RunTime). ���������� �����������������
'����� (�������) ����������.
'CommPort - ��������, Integer, ���������/ ������. �������������/ ���������� ����� �������������
'COM - �����. (���� "0" - ����������). ������� � ��������� 1�99, ������ ��� ��������
'��������������� ����� ����� ������������� ������. �������� ���������� ������ �� �������� �����.
'CTSHolding - ��������, Boolean, ������ ������ � ������ ���������� (RunTime). ���������� �����������
'�������� ������, �������� ��������� ������� Clear To Send (CTS) ������.
'DSRHolding - ��������, Boolean, ������ ������ � ������ ���������� (RunTime). ���������� ����������
'������ � ����� ������ �� �����.
'DTREnable - ��������, Boolean, ���������/ ������. ����������, ������� �� ���������� ������ Data Terminal
'Ready (DTR) �� ������ �������� ������. ��� �������� �������� ������ DTR ��������������� ���
'�������� ����� � ������������ ��� ��� ��������. ��� ���������� �������� ������ DTR ������
'������� ���������������. ������ DTR �������� ������, ��� ��������� ����� � ����� ������.
'EOFEnable - ��������, Boolean, ���������/ ������. �������������/ ���������� �������� ��� ����������
'����� ������.
'Handshacking - ��������, ���������, ���������/ ������. �������������/ ���������� �������� ������������
'��� �����. �������� �����������, ��� ������ �������� �� ����� ��� ������������ ������.
'InBufferCount - ��������, Integer, ������ ������. ���������� ���������� ��������, ������ � ����������
'������.
'InBufferSize - ��������, Integer, ���������/ ������. �������������/ ���������� ������ �������� ������
'� ������. �� ��������� 1024 �����.
'Index - ��������, Integer, ���������/ ������. �������������/ ���������� ���������� ����� ��������
'� ������� ���������.
'Input - ��������, Variant, ������ ������ � ������ ���������� (RunTime). ���������� � ������������
'������� ������� �� ����������� ������.
'InputLen - ��������, Integer, ���������/ ������. �������������/ ���������� ����� ����������� ��������
'��������� Input �� ������. �� ��������� �������� ����� "0", � ���� ������ ����� ����������� ��
'���������� ������. ���� � ������ ��� ������ ���������� ��������, �� ����� ���������� ������
'������.
'InputMode - ��������, ���������, ���������/ ������. �������������/ ���������� ��� ������, ����������
'� ������� �������� Input.
'Name - ��������, String, ������ ������. ���������� ���, ������������ � ����, ��� ��������� � �������.
'NullDiscard - ��������, Boolean, ���������/ ������. �������������/ ���������� ����, ����� ��
'������������ �� ����� � ����� ������ �������� Null.
'Object - ��������, Object, ������ ������. ���������� ������ � ������� ���������.
'OnComm - �������, ��� ����������. ����������, ����� �������� CommEvent ����������. ������������
'������� ��������.
'OutBufferCount - ��������, Integer, ������ ������ � ������ ���������� (RunTime). ���������� �����
'��������, ������ � ���������� ������. ��������� � "0" ������� �������� ������� ����������
'�����.
'OutBufferSize - ��������, Integer, ���������/ ������. �������������/ ���������� ������ �����������
'������ � ������. �� ��������� �� ����� 512 ����.
'Output - ��������, Variant, ������ ��������� � ������ ���������� (RunTime). ����������
'������������������ �������� � ���������� �����.
'Parent - ��������, Object, ������ ������. ���������� ������, �� ������� �������� ������ �������.
'ParityReplace - ��������, String, ���������/ ������. �������������/ ���������� ���������� ������
'� ������ ������ � ������ ������. �� ��������� - "?". ���� ������ �������� "" (������ ������),
'�� �������� �������� �����������.
'PortOpen - ��������, Boolean, ���������/ ������ � ������ ���������� (RunTime). �������������/
'���������� ��������� ����� �����, ���������/ ��������� ����. ��� �������� ����� �������������
'��������� ������ ����� � ��������. ��� �������� ���������� ���� ����������� �������������.
'� ������ �������� ������������� ����� ��������� ������.
'RThreshold - ��������, Integer, ���������/ ������. ����� ���������� ���������� �������� �����
'��� ��� ��������� ������� OnComm. ��� ��������� � "0" ������� �� ����� ��������������. ���
'��������� � "1" ������� ����� �������������� ��� ����������� ������� �������.
'RTSEnable - ��������, Boolean, ���������/ ������. ����� ����������� ������������� �������
'Request To Send (RTS). ������ RTS ����������� ���������� �� �������� ������ � ������.
'Settings - ��������, String, ���������/ ������. ����� ��������� ������ �����. ����� ��������� ���:
'"BBBB, P, D, S" ��� BBBB - �������� �������� � �����, P - ��������, D - ����� ����� ������,
'S - ����� ����-�����. �� ��������� �������� ����� ���: "9600, N, 8, 1". � ������ �������������
'������� ��������� ����� ������������� ������.
'�
'SThreshold - ��������, Integer, ���������/ ������. ����� ���������� �������� � ������ ��������, ���
'������� ��������� ������� OnComm. ��� ��������� � "0" ������� �� ����� ��������������. ���
'��������� � "1" ������� ����� �������������� ��� �������� ������� �������.
'Tag - ��������, String, ���������/ ������. ��������� ������ ��������������� ������������ ���������.
