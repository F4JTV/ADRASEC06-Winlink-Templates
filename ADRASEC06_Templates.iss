; ---------------------------------------------------------------------------
; Inno Setup script - ADRASEC 06 Winlink templates
;
; Installs the message and acknowledgement templates into the Winlink Express
; template tree, and optionally drops a copy on the desktop for transfer to an
; Android phone running WoAD.
;
; Build with Inno Setup 6:
;     "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" ADRASEC06_Templates.iss
;
; Expected layout next to this script:
;     ADRASEC06_Templates.iss
;     setup_icon.ico
;     setup_wizard.bmp
;     setup_wizard_small.bmp
;     ADRASEC06\            <- the template files themselves
; ---------------------------------------------------------------------------

#define AppName        "Modèles Winlink ADRASEC 06"
#define AppVersion     "1.0.0"
#define AppPublisher   "ADRASEC 06"
#define TemplateFolder "ADRASEC06"
#define WinlinkExe     "RMS Express.exe"

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
OutputBaseFilename=ADRASEC06_Templates_Setup_{#AppVersion}
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

[CustomMessages]
fr.DirPageCaption=Dossier de Winlink Express
fr.DirPageDescription=Où Winlink Express est-il installé ?
fr.DirPageLabel=Indiquez le dossier racine de Winlink Express. Les modèles seront placés dans son sous-dossier Global Folders\Templates\{#TemplateFolder}.
fr.NotWinlinkFolder=Le fichier "{#WinlinkExe}" est introuvable dans ce dossier.%n%nCe n'est probablement pas le dossier de Winlink Express, et les modèles ne seraient pas visibles dans l'application.%n%nVoulez-vous continuer malgré tout ?
fr.TaskWoad=Préparer une copie pour WoAD (Winlink on Android) sur le Bureau
fr.TaskGroupWoad=Android :
fr.OpenFolder=Ouvrir le dossier des modèles
fr.WoadNotice=Une copie des modèles a été placée sur votre Bureau, dans le dossier "{#TemplateFolder}_WoAD".%n%nPour WoAD : branchez le téléphone en USB et copiez le CONTENU de ce dossier dans Android\data\com.sumusltd.woad\files, puis réglez Settings - Message template - Other templates location sur "App-specific External" et redémarrez WoAD.%n%nUn dossier partagé choisi avec le sélecteur de fichiers Android ne fonctionne pas : WoAD y liste les modèles mais n'ouvre pas les formulaires HTML.

[Tasks]
Name: "woad"; Description: "{cm:TaskWoad}"; GroupDescription: "{cm:TaskGroupWoad}"; Flags: unchecked

[Files]
; Winlink Express
Source: "{#TemplateFolder}\*"; DestDir: "{app}\Global Folders\Templates\{#TemplateFolder}"; Flags: ignoreversion recursesubdirs createallsubdirs

; Optional copy staged on the desktop for manual transfer to the phone
Source: "{#TemplateFolder}\*"; DestDir: "{userdesktop}\{#TemplateFolder}_WoAD"; Flags: ignoreversion recursesubdirs createallsubdirs uninsneveruninstall; Tasks: woad

[Run]
Filename: "{win}\explorer.exe"; Parameters: """{app}\Global Folders\Templates\{#TemplateFolder}"""; Description: "{cm:OpenFolder}"; Flags: postinstall nowait skipifsilent unchecked

[UninstallDelete]
Type: filesandordirs; Name: "{app}\Global Folders\Templates\{#TemplateFolder}"

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
  end;
end;

{ Warn, without blocking, when the chosen folder holds no Winlink Express. }
function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
  if CurPageID = wpSelectDir then
  begin
    if not FileExists(WizardDirValue + '\{#WinlinkExe}') then
      Result := MsgBox(ExpandConstant('{cm:NotWinlinkFolder}'), mbConfirmation, MB_YESNO) = IDYES;
  end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
begin
  if (CurStep = ssPostInstall) and WizardIsTaskSelected('woad') then
    MsgBox(ExpandConstant('{cm:WoadNotice}'), mbInformation, MB_OK);
end;
