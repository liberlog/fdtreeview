object DlgPreferences: TDlgPreferences
  Left = 374
  Top = 166
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Pr'#233'f'#233'rences'
  ClientHeight = 250
  ClientWidth = 525
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    000007170000000000000117F700000000007110F700000000001170F7000000
    00071100F700000000011700F700000000711000F700070700117002242078F0
    0711000024000F8071170000A400700000100000A400007000777000A4000007
    00070000A400000070000000A40000000000000000000000000000000000FF8F
    0000FF830000FF130000FF130000FE330000FE330000FC7300008C61000008F3
    000000E1000001E10000C0610000E0610000F0E10000FFF30000FFFF0000}
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 218
    Width = 525
    Height = 32
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      525
      32)
    object BtnOk: TBitBtn
      Left = 446
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 0
      Kind = bkOK
    end
    object BtnCancel: TBitBtn
      Left = 369
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 1
      Kind = bkCancel
    end
  end
  object GroupBox1: TGroupBox
    Left = 0
    Top = 6
    Width = 525
    Height = 212
    Align = alBottom
    Caption = ' Noeud '
    TabOrder = 1
    object Label1: TLabel
      Left = 12
      Top = 20
      Width = 42
      Height = 13
      Alignment = taRightJustify
      Caption = 'Largeur :'
    end
    object Label2: TLabel
      Left = 10
      Top = 44
      Width = 44
      Height = 13
      Alignment = taRightJustify
      Caption = 'Hauteur :'
    end
    object LabelEspacementH: TLabel
      Left = 172
      Top = 20
      Width = 113
      Height = 13
      Alignment = taRightJustify
      Caption = 'Espacement horizontal :'
    end
    object LabelEspacementV: TLabel
      Left = 183
      Top = 44
      Width = 102
      Height = 13
      Alignment = taRightJustify
      Caption = 'Espacement vertical :'
    end
    object BtnFeuille1: TButton
      Left = 12
      Top = 72
      Width = 75
      Height = 25
      Caption = 'Un noeud'
      TabOrder = 0
    end
    object EditHauteur: TRxSpinEdit
      Left = 68
      Top = 40
      Width = 61
      Height = 21
      MaxValue = 50.000000000000000000
      MinValue = 10.000000000000000000
      Value = 10.000000000000000000
      TabOrder = 1
      OnChange = EditLargeurChange
    end
    object EditLargeur: TRxSpinEdit
      Left = 68
      Top = 16
      Width = 61
      Height = 21
      MaxValue = 130.000000000000000000
      MinValue = 20.000000000000000000
      Value = 20.000000000000000000
      TabOrder = 2
      OnChange = EditLargeurChange
    end
    object BtnFeuille2: TButton
      Left = 128
      Top = 72
      Width = 75
      Height = 25
      Caption = 'Un noeud'
      TabOrder = 3
    end
    object BtnFeuille3: TButton
      Left = 12
      Top = 116
      Width = 75
      Height = 25
      Caption = 'Un noeud'
      TabOrder = 4
    end
    object EditHIdent: TRxSpinEdit
      Left = 296
      Top = 16
      Width = 61
      Height = 21
      MaxValue = 150.000000000000000000
      MinValue = 5.000000000000000000
      Value = 5.000000000000000000
      TabOrder = 5
      OnChange = EditLargeurChange
    end
    object EditVIdent: TRxSpinEdit
      Left = 296
      Top = 40
      Width = 61
      Height = 21
      MaxValue = 100.000000000000000000
      MinValue = 5.000000000000000000
      Value = 5.000000000000000000
      TabOrder = 6
      OnChange = EditLargeurChange
    end
  end
end
