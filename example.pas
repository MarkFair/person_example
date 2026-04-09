{-----------------------------------------------------------------------------
 Unit Name: UDBlowerEqEval
 Author:    fairlamb
 Date:      08-Dec-2014
 Purpose:
 History:
-----------------------------------------------------------------------------}


unit UDBlowerEqEval;

interface

uses Classes, AtMath;

type
 TUDPowerEquEval = class(TatMathEvaluator)
  private
  protected
  public
    fPolytropic : f4;
    fAdiabatic,
    fLinear : f3;
    constructor Create(AOwner : TComponent); override;
    procedure PMFClear;
//    function AddVariables(SingleReactor : TBioreactorElement) : boolean;
    function AddConstants(CurCsts : TStringList) : boolean;
  published
 end;



implementation

uses SysUtils, Math, Dialogs, UConvert, Resources, OptimU, BlowerEquationDefsU;

constructor TUDPowerEquEval.Create(AOwner : TComponent);
begin
 inherited;
 PMFClear;
end;

procedure TUDPowerEquEval.PMFClear;
begin
 Start;  // clear all constants, functions and operators then add predefined ones
 // Now add My predefined ones
 fPolytropic := PolytropicPowerEq;
 fAdiabatic := AdiabaticPowerEq;
 fLinear := LinearPowerEq;
 Functions.Add('PolytropicPower',4,@fPolytropic);
 Functions.Add('AdiabaticPower',3,@fAdiabatic);
 Functions.Add('LinearPower',3,@fLinear);
end;

//function TUDPowerEquEval.AddVariables(SingleReactor : TBioreactorElement) : boolean;
//begin
//  Variables.Clear;
//  Variables.Add(il_PField,@SingleReactor.fPField,nil);
//  Variables.Add(il_PDischarge,@SingleReactor.FPDischarge,nil);
//  Variables.Add(il_StdAirFlow,@SingleReactor.fBlowerStdGasflow,nil);
//  result := (Variables.Count = 3);
//end;

function TUDPowerEquEval.AddConstants(CurCsts : TStringList) : boolean;
var
  CCode, i : integer;
  ID : String;
  CVal : ExtPres;
begin
  result := true;
  try
    for i := 0 to CurCsts.Count-1 do
     begin
       ID := CurCsts.Names[i];
       Val(CurCsts.Values[ID],CVal,ccode);
       if ccode <> 0 then
        begin
          ShowMessage(Format(rs_fs_InvalidConstant_S_value_S_Zero_Substituted,[ID,CurCsts.Values[ID]]));
          CurCsts.Values[ID] := '0';
          CVal := 0;
        end;
       Constants.Add(ID,CVal,0);
     end;
  except
    result := false;  // exception causes failure
  end;
end;

end.
