; ---------------------------------------------------------------------------
; Inno Setup script - Winlink templates for ADRASEC 06
;
; Installs two independent sets of Winlink Express templates, selectable at
; install time:
;   - ADRASEC 06 : message (ambiance / situation / encapsulated / coded) + ack
;   - FNRASEC    : the six official FNRASEC templates, version 25.10.1
;
; Both can optionally be staged on the desktop for transfer to an Android
; phone running WoAD.
;
; Build with Inno Setup 6:
;     "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" ADRASEC06_Templates.iss
;
; Expected layout next to this script:
;     ADRASEC06_Templates.iss
;     setup_icon.ico
;     setup_wizard.bmp
;     setup_wizard_small.bmp
;     ADRASEC06\            <- ADRASEC 06 template files
;     FNRASEC\              <- FNRASEC template files (MIT, see LICENSE_FNRASEC.md)
;
; The FNRASEC templates are the work of Jean-Louis Zola (F4IXH), redistributed
; here under the MIT licence; their copyright notice ships in the FNRASEC
; folder as LICENSE_FNRASEC.md. The .md extension is deliberate: Winlink lists
; every .txt file in a template folder as a template, so a licence named .txt
; would show up as a broken entry in the template list.
; ---------------------------------------------------------------------------

#define AppName        "Modèles Winlink ADRASEC 06 et FNRASEC"
#define AppVersion     "1.1.0"
#define AppPublisher   "ADRASEC 06"
#define FolderA06      "ADRASEC06"
#define FolderFNR      "FNRASEC"
#define WoadFolder     "Winlink_WoAD"
#define WinlinkExe     "RMS Express.exe"
#define TemplateRoot   "Global Folders\Templates"

[Setup]
AppId={{8F3C1A42-5D77-4B96-9E21-7C4B0A6D3E51}
AppName={#AppName}
AppVersion={#AppVersion}
AppVerName={#AppName} {#AppVersion}
AppPublisher={#AppPublisher}
VersionInfoVersion={#AppVersion}
VersionInfoDescription={#AppName}

; {app} is the Winlink Express root, not a classic program folder:
; the templates are written into its "Global Folders\Templates" subtree.
DefaultDirName={code:DefaultWinlinkDir}
DirExistsWarning=no
AppendDefaultDirName=no
UsePreviousAppDir=yes
DisableProgramGroupPage=yes
DisableReadyPage=no
AllowNoIcons=yes

OutputDir=.
OutputBaseFilename=Modeles_Winlink_Setup_{#AppVersion}
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
SetupIconFile=setup_icon.ico
WizardImageFile=setup_wizard.bmp
WizardSmallImageFile=setup_wizard_small.bmp
UninstallDisplayName={#AppName}
UninstallDisplayIcon={app}\{#WinlinkExe}

; Writing under C:\RMS Express usually needs elevation; let the user decide
; if their installation sits somewhere writable.
PrivilegesRequired=admin
PrivilegesRequiredOverridesAllowed=dialog

[Languages]
Name: "fr"; MessagesFile: "compiler:Languages\French.isl"

[Types]
Name: "complet";      Description: "{cm:TypeComplet}"
Name: "adrasec_seul"; Description: "{cm:TypeAdrasec}"
Name: "fnrasec_seul"; Description: "{cm:TypeFnrasec}"
Name: "personnalise"; Description: "{cm:TypePerso}"; Flags: iscustom

[Components]
Name: "adrasec06"; Description: "{cm:CompAdrasec}"; Types: complet adrasec_seul
Name: "fnrasec";   Description: "{cm:CompFnrasec}"; Types: complet fnrasec_seul

[CustomMessages]
fr.TypeComplet=Les deux jeux de modèles (recommandé)
fr.TypeAdrasec=Modèles ADRASEC 06 uniquement
fr.TypeFnrasec=Modèles FNRASEC uniquement
fr.TypePerso=Installation personnalisée

fr.CompAdrasec=Modèles ADRASEC 06 (message et accusé de réception)
fr.CompFnrasec=Modèles FNRASEC 25.10.1 (six formulaires officiels)

fr.ComponentsCaption=Modèles à installer
fr.ComponentsDescription=Quels jeux de modèles voulez-vous installer ?
fr.NoComponent=Sélectionnez au moins un jeu de modèles pour continuer.

fr.DirPageCaption=Dossier de Winlink Express
fr.DirPageDescription=Où Winlink Express est-il installé ?
fr.DirPageLabel=Indiquez le dossier racine de Winlink Express. Les modèles seront placés dans son sous-dossier {#TemplateRoot}.
fr.NotWinlinkFolder=Le fichier "{#WinlinkExe}" est introuvable dans ce dossier.%n%nCe n'est probablement pas le dossier de Winlink Express, et les modèles ne seraient pas visibles dans l'application.%n%nVoulez-vous continuer malgré tout ?
fr.FolderExists=Le dossier de modèles suivant existe déjà :%n%n%1%n%nSon contenu va être remplacé par cette installation, et la désinstallation supprimera le dossier entier.%n%nSi vous y avez placé des modèles personnels, sauvegardez-les avant de continuer.%n%nContinuer ?

fr.TaskWoad=Préparer une copie pour WoAD (Winlink on Android) sur le Bureau
fr.TaskGroupWoad=Android :
fr.OpenFolder=Ouvrir le dossier des modèles
fr.WoadNotice=Une copie des modèles a été placée sur votre Bureau, dans le dossier "{#WoadFolder}".%n%nPour WoAD : branchez le téléphone en USB et copiez le CONTENU de ce dossier dans Android\data\com.sumusltd.woad\files, puis réglez Settings - Message template - Other templates location sur "App-specific External" et redémarrez WoAD.%n%nUn dossier partagé choisi avec le sélecteur de fichiers Android ne fonctionne pas : WoAD y liste les modèles mais n'ouvre pas les formulaires HTML.

[Tasks]
Name: "woad"; Description: "{cm:TaskWoad}"; GroupDescription: "{cm:TaskGroupWoad}"; Flags: unchecked

[Files]
; --- Winlink Express ---
Source: "{#FolderA06}\*"; DestDir: "{app}\{#TemplateRoot}\{#FolderA06}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: adrasec06
Source: "{#FolderFNR}\*"; DestDir: "{app}\{#TemplateRoot}\{#FolderFNR}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: fnrasec

; --- Optional flat copy for WoAD, staged on the desktop ---
; Flat on purpose: WoAD is not reliable at descending into subfolders, so the
; user copies the contents of a single folder onto the phone. The ADRASEC 06
; and FNRASEC file names do not collide.
Source: "{#FolderA06}\*"; DestDir: "{userdesktop}\{#WoadFolder}"; Flags: ignoreversion uninsneveruninstall; Components: adrasec06; Tasks: woad
Source: "{#FolderFNR}\*"; DestDir: "{userdesktop}\{#WoadFolder}"; Flags: ignoreversion uninsneveruninstall; Components: fnrasec;   Tasks: woad

[Run]
Filename: "{win}\explorer.exe"; Parameters: """{app}\{#TemplateRoot}"""; Description: "{cm:OpenFolder}"; Flags: postinstall nowait skipifsilent unchecked

; Each folder is removed only if its component was part of this installation,
; so uninstalling an ADRASEC-only setup leaves an FNRASEC folder installed by
; other means untouched.
[UninstallDelete]
Type: filesandordirs; Name: "{app}\{#TemplateRoot}\{#FolderA06}"; Components: adrasec06
Type: filesandordirs; Name: "{app}\{#TemplateRoot}\{#FolderFNR}"; Components: fnrasec

[Code]

{ Returns the first plausible Winlink Express root, or an empty string. }
function FindWinlinkDir(): String;
var
  Candidates: TArrayOfString;
  I: Integer;
begin
  Result := '';
  SetArrayLength(Candidates, 5);
  Candidates[0] := 'C:\RMS Express';
  Candidates[1] := ExpandConstant('{sd}\RMS Express');
  Candidates[2] := ExpandConstant('{commonpf32}\RMS Express');
  Candidates[3] := ExpandConstant('{commonpf}\RMS Express');
  Candidates[4] := ExpandConstant('{localappdata}\RMS Express');

  for I := 0 to GetArrayLength(Candidates) - 1 do
  begin
    if FileExists(Candidates[I] + '\{#WinlinkExe}') then
    begin
      Result := Candidates[I];
      Exit;
    end;
  end;
end;

{ Default value of the directory page. }
function DefaultWinlinkDir(Param: String): String;
begin
  Result := FindWinlinkDir();
  if Result = '' then
    Result := 'C:\RMS Express';
end;

procedure InitializeWizard();
begin
  WizardForm.SelectDirLabel.Caption := ExpandConstant('{cm:DirPageLabel}');
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  if CurPageID = wpSelectDir then
  begin
    WizardForm.PageNameLabel.Caption := ExpandConstant('{cm:DirPageCaption}');
    WizardForm.PageDescriptionLabel.Caption := ExpandConstant('{cm:DirPageDescription}');
  end
  else if CurPageID = wpSelectComponents then
  begin
    WizardForm.PageNameLabel.Caption := ExpandConstant('{cm:ComponentsCaption}');
    WizardForm.PageDescriptionLabel.Caption := ExpandConstant('{cm:ComponentsDescription}');
  end;
end;

{ Asks before overwriting a template folder that is already there, because
  uninstalling later removes that folder whole. }
function ConfirmExisting(Folder: String): Boolean;
var
  Full: String;
begin
  Result := True;
  Full := WizardDirValue + '\{#TemplateRoot}\' + Folder;
  if DirExists(Full) then
    Result := MsgBox(FmtMessage(ExpandConstant('{cm:FolderExists}'), [Full]),
                     mbConfirmation, MB_YESNO) = IDYES;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;

  if CurPageID = wpSelectComponents then
  begin
    if not (WizardIsComponentSelected('adrasec06') or WizardIsComponentSelected('fnrasec')) then
    begin
      MsgBox(ExpandConstant('{cm:NoComponent}'), mbError, MB_OK);
      Result := False;
    end;
  end

  else if CurPageID = wpSelectDir then
  begin
    if not FileExists(WizardDirValue + '\{#WinlinkExe}') then
      Result := MsgBox(ExpandConstant('{cm:NotWinlinkFolder}'), mbConfirmation, MB_YESNO) = IDYES;

    if Result and WizardIsComponentSelected('adrasec06') then
      Result := ConfirmExisting('{#FolderA06}');
    if Result and WizardIsComponentSelected('fnrasec') then
      Result := ConfirmExisting('{#FolderFNR}');
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if (CurStep = ssPostInstall) and WizardIsTaskSelected('woad') then
    MsgBox(ExpandConstant('{cm:WoadNotice}'), mbInformation, MB_OK);
end;
