object DlgSetNodeProperties: TDlgSetNodeProperties
  Left = 313
  Top = 239
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Ajouter / Modifier un noeud'
  ClientHeight = 311
  ClientWidth = 421
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 8
    Width = 42
    Height = 13
    Caption = 'Caption :'
  end
  object Image1: TImage
    Left = 95
    Top = 63
    Width = 253
    Height = 153
  end
  object Label2: TLabel
    Left = 4
    Top = 132
    Width = 44
    Height = 13
    Caption = 'Nb Glyph'
  end
  object Panel1: TPanel
    Left = 0
    Top = 279
    Width = 421
    Height = 32
    Align = alBottom
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      421
      32)
    object BtnOk: TBitBtn
      Left = 344
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 0
      Kind = bkOK
    end
    object BtnCancel: TBitBtn
      Left = 268
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      TabOrder = 1
      Kind = bkCancel
    end
  end
  object EditCaption: TEdit
    Left = 52
    Top = 4
    Width = 121
    Height = 21
    TabOrder = 1
    Text = 'Caption'
  end
  object BtnFontCaption: TBitBtn
    Left = 4
    Top = 32
    Width = 169
    Height = 25
    Caption = 'Font Caption'
    TabOrder = 2
    OnClick = BtnFontCaptionClick
  end
  object BtnGlyph: TBitBtn
    Left = 4
    Top = 60
    Width = 85
    Height = 65
    Caption = 'Glyph'
    TabOrder = 3
    OnClick = BtnGlyphClick
  end
  object EditNumGlyph: TSpinEdit
    Left = 56
    Top = 128
    Width = 33
    Height = 22
    MaxValue = 4
    MinValue = 1
    TabOrder = 4
    Value = 2
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 240
    Top = 40
  end
end
