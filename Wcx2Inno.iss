// Any of my ideas written below can be used and/or shared in the Free projects/websites only.
// Where there is no profit even from ads.
//
// In any other way of use, you have to support me.
// You also need to earn money to live on this World.
//
// https://ko-fi.com/Wilenty
//
// https://wilenty.wixsite.com/links
//
// Define (Total Commander) WCX Name of the plug-in to use, here:
#Define WcxDLL="YoursFileNameHere.wcx"
// And that's all, you don't need to change anything below to test it. :-)

[Setup]
#Define Wcx2Inno=RemoveFileExt(ExtractFileName(WcxDLL)) + "2Inno"
AppName={#Wcx2Inno} Example by Wilenty
AppVersion=0.1
;AppVerName={#Wcx2Inno} Example v0.1 by Wilenty
Uninstallable=No
CreateUninstallRegKey=No
PrivilegesRequired=PowerUser
CreateAppDir=False
#Define ModernClassic=Ver < 0x06020000 ? "Modern" : "Classic"
WizardImageFile=compiler:Wiz{#ModernClassic}Image-IS.bmp
WizardSmallImageFile=compiler:Wiz{#ModernClassic}SmallImage-IS.bmp
#UnDef ModernClassic
OutputBaseFilename={#Wcx2Inno}
#UnDef Wcx2Inno

[Files]
// You must define your own plugin in the '#Define WcxDLL="*.wcx"' above to make it work, don't write it below!
Source: "{#WcxDLL}"; DestDir: "{tmp}"; Flags: IgnoreVersion DontCopy
#If Ver < 0x06000000
Source: "CallbackCtrl.dll"; DestDir: "{tmp}"; Flags: IgnoreVersion DontCopy
#EndIf

[code]
const       {Error codes returned to calling application}
  E_Success=         0;        { Everything OK! }
  E_END_ARCHIVE=     10;       {No more files in archive}
  E_NO_MEMORY=       11;       {Not enough memory}
  E_BAD_DATA=        12;       {CRC error in the data of the currently unpacked file}
  E_BAD_ARCHIVE=     13;       {The archive as a whole is bad, e.g. damaged headers}
  E_UNKNOWN_FORMAT=  14;       {Archive format unknown}
  E_EOPEN=           15;       {Cannot open existing file}
  E_ECREATE=         16;       {Cannot create file}
  E_ECLOSE=          17;       {Error closing file}
  E_EREAD=           18;       {Error reading from file}
  E_EWRITE=          19;       {Error writing to file}
  E_SMALL_BUF=       20;       {Buffer too small}
  E_EABORTED=        21;       {Function aborted by user}
  E_NO_FILES=        22;       {No files found}
  E_TOO_MANY_FILES=  23;       {Too many files to pack}
  E_NOT_SUPPORTED=   24;       {Function not supported}
 
  {Unpacking flags}
  PK_OM_LIST=           0;
  PK_OM_EXTRACT=        1;
 
  {Flags for ProcessFile}
  PK_SKIP=              0;     {Skip file (no unpacking)}
  PK_TEST=              1;     {Test file integrity}
  PK_EXTRACT=           2;     {Extract file to disk}

  { THeaderData*.FileAttr contains one or more attributes of: }
  FA_Read_only = $1; // Read-only file
  FA_Hidden =    $2; // Hidden file
  FA_System =    $4; // System file
  FA_Volume_ID = $8; // Volume ID file
  FA_Directory = $10; // Directory
  FA_Archive =   $20; // Archive file
  FA_Any_file =  $3F; // Any file

  {Flags passed through ChangeVolProc}
  PK_VOL_ASK=           0;     {Ask user for location of next volume}
  PK_VOL_NOTIFY=        1;     {Notify app that next volume will be unpacked}
 
  {Packing flags}
 
  {For PackFiles}
  PK_PACK_MOVE_FILES=   1;    {Delete original after packing}
  PK_PACK_SAVE_PATHS=   2;    {Save path names of files}
  PK_PACK_ENCRYPT=      4;    {Ask user for password, then encrypt}
 
 
  {Returned by GetPackCaps}
  PK_CAPS_NEW=          1;    {Can create new archives}
  PK_CAPS_MODIFY=       2;    {Can modify exisiting archives}
  PK_CAPS_MULTIPLE=     4;    {Archive can contain multiple files}
  PK_CAPS_DELETE=       8;    {Can delete files}
  PK_CAPS_OPTIONS=     16;    {Supports the options dialogbox}
  PK_CAPS_MEMPACK=     32;    {Supports packing in memory}
  PK_CAPS_BY_CONTENT=  64;    {Detect archive type by content}
  PK_CAPS_SEARCHTEXT= 128;    {Allow searching for text in archives
                              { created with this plugin}
  PK_CAPS_HIDE=       256;    { Show as normal files (hide packer icon) }
                              { open with Ctrl+PgDn, not Enter }
  PK_CAPS_ENCRYPT=    512;    { Plugin supports PK_PACK_ENCRYPT option }
 
  BACKGROUND_UNPACK=1;        { Which operations are thread-safe? }
  BACKGROUND_PACK=2;
  BACKGROUND_MEMPACK=4;       { For tar.pluginext in background }
 
  {Flags for packing in memory}
  MEM_OPTIONS_WANTHEADERS=1;  {Return archive headers with packed data}
 
  {Errors returned by PackToMem}
  MEMPACK_OK=           0;    {Function call finished OK, but there is more data}
  MEMPACK_DONE=         1;    {Function call finished OK, there is no more data}
 
  {Flags for PkCryptProc callback}
  PK_CRYPT_SAVE_PASSWORD=1;
  PK_CRYPT_LOAD_PASSWORD=2;
  PK_CRYPT_LOAD_PASSWORD_NO_UI=3;   { Load password only if master password has already been entered!}
  PK_CRYPT_COPY_PASSWORD=4;         { Copy encrypted password to new archive name}
  PK_CRYPT_MOVE_PASSWORD=5;         { Move password when renaming an archive}
  PK_CRYPT_DELETE_PASSWORD=6;       { Delete password}

  PK_CRYPTOPT_MASTERPASS_SET = 1;   // The user already has a master password defined

type
  {Definition of callback functions called by the DLL}
  {Ask to swap disk for multi-volume archive}
//  PChangeVolProc = ^TChangeVolProc;
  TChangeVolProc = function(ArcName: PAnsiChar; Mode: longInt): longInt;
#If Defined Unicode
//  PChangeVolProcW = ^TChangeVolProcW;
  TChangeVolProcW = function(ArcName: String; Mode: longInt): longInt;
#EndIf

  {Notify that data is processed - used for progress dialog}
//  PProcessDataProc = ^TProcessDataProc;
  TProcessDataProc = function(FileName: PAnsiChar; Size: longInt): longInt;
#If Defined Unicode
//  PProcessDataProcW = ^TProcessDataProcW;
  TProcessDataProcW = function(FileName: String; Size: longInt): longInt;
#EndIf
//  PPkPluginCryptProc = ^TPkPluginCryptProc;
  TPkPluginCryptProc = function(CryptoNr: integer; mode: integer; ArchiveName, Password: PAnsiChar; maxlen: integer): integer;
#If Defined Unicode
//  PPkPluginCryptProcW = ^TPkPluginCryptProcW;
  TPkPluginCryptProcW = function(CryptoNr: integer; mode: integer; ArchiveName, Password: String; maxlen: integer): integer;
#EndIf

type
  THeaderData = record
    ArcName: array [0..259] of AnsiChar;
    FileName: array [0..259] of AnsiChar;
    Flags,
    PackSize,
    UnpSize,
    HostOS,
    FileCRC,
    FileTime,
    UnpVer,
    Method,
    FileAttr: longInt;
    CmtBuf: PAnsiChar;
    CmtBufSize,
    CmtSize,
    CmtState: longInt;
  end;
 
  THeaderDataEx = record
    ArcName: array [0..1023] of Ansichar;
    FileName: array [0..1023] of Ansichar;
    Flags: longInt;
    PackSize,
    PackSizeHigh,
    UnpSize,
    UnpSizeHigh: DWORD;
    HostOS,
    FileCRC,
    FileTime,
    UnpVer,
    Method,
    FileAttr: longInt;
    CmtBuf: PAnsiChar;
    CmtBufSize,
    CmtSize,
    CmtState: longInt;
    Reserved: array[0..1023] of Char;
  end;

#If Defined Unicode
  THeaderDataExW = record
    ArcName: array [0..1023] of WideChar;
    FileName: array [0..1023] of WideChar;
    Flags: longInt;
    PackSize,
    PackSizeHigh,
    UnpSize,
    UnpSizeHigh: DWORD;
    HostOS,
    FileCRC,
    FileTime,
    UnpVer,
    Method,
    FileAttr: longInt;
    CmtBuf: PAnsiChar;
    CmtBufSize,
    CmtSize,
    CmtState: longInt;
    Reserved: array[0..1023] of Char;
  end;
#EndIf

  tOpenArchiveData = record
    ArcName: PAnsiChar;
    OpenMode,
    OpenResult: longInt;
    CmtBuf: PAnsiChar;
    CmtBufSize,
    CmtSize,
    CmtState: longInt;
  end;
 
#If Defined Unicode
  tOpenArchiveDataW = record
    ArcName: String;
    OpenMode,
    OpenResult: longInt;
    CmtBuf: String;
    CmtBufSize,
    CmtSize,
    CmtState: longInt;
  end;
#EndIf

  tPackDefaultParamStruct = record
    size,
    PluginInterfaceVersionLow,
    PluginInterfaceVersionHi: longInt;
    DefaultIniName: array[0..259] of AnsiChar;
  end;
//  pPackDefaultParamStruct=^tPackDefaultParamStruct;

#If Defined Unicode
  tPackDefaultParamStructW = record
    size,
    PluginInterfaceVersionLow,
    PluginInterfaceVersionHi: longInt;
    DefaultIniName: array[0..259] of WideChar;
  end;
//  pPackDefaultParamStructW=^tPackDefaultParamStructW;
#EndIf

#Define WcxDLL=ExtractFileName(WcxDLL)

Function CanYouHandleThisFile(FileName: PAnsiChar): BOOL;
  External 'CanYouHandleThisFile@files:{#WcxDLL} stdcall delayload';
 
#If defined Unicode
Function CanYouHandleThisFileW(FileName: String): BOOL;
  External 'CanYouHandleThisFileW@files:{#WcxDLL} stdcall delayload';
#EndIf

Function OpenArchive(ArchiveData: tOpenArchiveData): THANDLE;
  External 'OpenArchive@files:{#WcxDLL} stdcall delayload';

#If defined Unicode
Function OpenArchiveW(ArchiveData: tOpenArchiveDataW): THANDLE;
  External 'OpenArchiveW@files:{#WcxDLL} stdcall delayload';
#EndIf

Function ReadHeader(hArcData: THANDLE; var HeaderData: tHeaderData): integer;
  External 'ReadHeader@files:{#WcxDLL} stdcall delayload';

Function ProcessFile(hArcData: THANDLE; Operation: integer; DestPath, DestName: PAnsiChar): integer;
  External 'ProcessFile@files:{#WcxDLL} stdcall delayload';

#If defined Unicode
Function ProcessFileW(hArcData: THANDLE; Operation: integer; DestPath, DestName: String): integer;
  External 'ProcessFileW@files:{#WcxDLL} stdcall delayload';
#EndIf

Function CloseArchive(hArcData: THANDLE): integer;
  External 'CloseArchive@files:{#WcxDLL} stdcall delayload';

Procedure SetChangeVolProc(hArcData: THANDLE; pChangeVolProc1: tChangeVolProc);
  External 'SetChangeVolProc@files:{#WcxDLL} stdcall delayload';

#If defined Unicode
Procedure SetChangeVolProcW(hArcData: THANDLE; pChangeVolProc1: tChangeVolProcW);
  External 'SetChangeVolProcW@files:{#WcxDLL} stdcall delayload';
#EndIf

Procedure SetProcessDataProc(hArcData: THANDLE; pProcessDataProc: Cardinal);
  External 'SetProcessDataProc@files:{#WcxDLL} stdcall delayload';

#If defined Unicode
Procedure SetProcessDataProcW(hArcData: THANDLE; pProcessDataProc: Cardinal);
  External 'SetProcessDataProcW@files:{#WcxDLL} stdcall delayload';
#EndIf

Function PackFiles(PackedFile, SubPath, SrcPath, AddList: PAnsiChar; Flags: integer): integer;
  External 'PackFiles@files:{#WcxDLL} stdcall delayload';

#If defined Unicode
Function PackFilesW(PackedFile, SubPath, SrcPath, AddList: String; Flags: integer): integer;
  External 'PackFilesW@files:{#WcxDLL} stdcall delayload';
#EndIf

Function DeleteFiles(PackedFile, DeleteList: PAnsiChar): integer;
  External 'DeleteFiles@files:{#WcxDLL} stdcall delayload';

#If defined Unicode
Function DeleteFilesW(PackedFile, DeleteList: String): integer;
  External 'DeleteFilesW@files:{#WcxDLL} stdcall delayload';
#EndIf

Function GetPackerCaps(): integer;
  External 'GetPackerCaps@files:{#WcxDLL} stdcall delayload';

Procedure ConfigurePacker(Parent: HWND; DllInstance: THANDLE);
  External 'ConfigurePacker@files:{#WcxDLL} stdcall delayload';

Function ReadHeaderEx(hArcData: THANDLE; var HeaderDataEx: tHeaderDataEx): integer;
  External 'ReadHeaderEx@files:{#WcxDLL} stdcall delayload';

#If defined Unicode
Function ReadHeaderExW(hArcData: THANDLE; var HeaderDataExW: THeaderDataExW): integer;
  External 'ReadHeaderExW@files:{#WcxDLL} stdcall delayload';
#EndIf

Function GetBackgroundFlags(): integer;
  External 'GetBackgroundFlags@files:{#WcxDLL} stdcall delayload';

Type
// If compiler throws an error on the "TArrayOfAnsiChar", comment/delete it along with the "Type" above.
  TArrayOfAnsiChar = Array of AnsiChar;

Function ArrayOfAnsiChar2String(ArrayOfChar: TArrayOfAnsiChar): AnsiString;
  Var
    Int1: Integer;
  Begin
    SetLength(Result, 0);
    For Int1 := 0 To GetArrayLength(ArrayOfChar)-1 do
      if ArrayOfChar[Int1] = #0 then
        Break
      else
        Result := Result + ArrayOfChar[Int1];
end;

Function String2ArrayOfAnsiChar(aStr: AnsiString): TArrayOfAnsiChar;
  Var
    Int: Integer;
  Begin
    SetArrayLength(Result, 0);
    SetArrayLength(Result, Length(aStr)+1);
    For Int := 1 To Length(aStr) do
      Result[Int-1] := aStr[Int];
end;

#If defined Unicode
Type
// If compiler throws an error on the "TArrayOfWideChar", comment/delete it along with the "Type" above.
  TArrayOfWideChar = Array of WideChar;

Function ArrayOfWideChar2String(ArrayOfWideChar: TArrayOfWideChar): String;
  Var
    Int: Integer;
  Begin
    SetLength(Result, 0);
    For Int := 0 To GetArrayLength(ArrayOfWideChar)-1 do
      if ArrayOfWideChar[Int] = #0 then
        Break
      else
        Result := Result + ArrayOfWideChar[Int];
end;

Function String2ArrayOfWideChar(wStr: String): TArrayOfWideChar;
  Var
    Int: Integer;
  Begin
    SetArrayLength(Result, 0);
    SetArrayLength(Result, Length(wStr)+1);
    For Int := 1 To Length(wStr) do
      Result[Int-1] := wStr[Int];
end;
#EndIf

Var
  PackerCaps: Integer;

(*
  CanYouOpenThisFile result:
    -1 the WCX plugin can't detect archive by its content
     0 the FileName can't be opened by this WCX plugin
     1 WCX plugin can open this FileName
*)
Function CanYouOpenThisFile(FileName: PAnsiChar): Integer;
  Var
    CanYouHandleThis: Boolean;
  begin
    Result := -1;
    if PackerCaps and PK_CAPS_BY_CONTENT = PK_CAPS_BY_CONTENT then
    begin
      #IfDef Unicode
      Try
        CanYouHandleThis := CanYouHandleThisFileW(FileName);
      except
      #EndIf
        Try
          CanYouHandleThis := CanYouHandleThisFile(FileName);
        except
          exit;
        end;
      #IfDef Unicode
      end;
      #EndIf
      if CanYouHandleThis then
        Result := 1
      else
        Result := 0;
    end;
end;

Var
  ArcHandle: THandle;
  OpenArchiveData: TOpenArchiveData;
  #IfDef Unicode
  OpenArchiveDataW: TOpenArchiveDataW;
  #EndIf

Function WcxOpenArchive(FileName: PAnsiChar; Mode2Open: Integer): Boolean;
  Begin
    If ArcHandle <> 0 then
      CloseArchive(ArcHandle);
    With OpenArchiveData do
    begin
      ArcName := FileName;
      OpenMode := Mode2Open;
    end; // OpenArchiveData.
    #IfDef Unicode
    With OpenArchiveDataW do
    begin
      ArcName := FileName;
      OpenMode := Mode2Open;
    end; // OpenArchiveDataW.
    Try
      ArcHandle := OpenArchiveW(OpenArchiveDataW);
    except
    #EndIf
      ArcHandle := OpenArchive(OpenArchiveData);
    #IfDef Unicode
    end;
    #EndIf
    Result := ArcHandle <> 0;
end;

Function WcxListArchive(SortFiles: Boolean; out UnpackSize, NumberOfFiles, NumberOfDirs: {#Defined Unicode ? "Int64" : "LongInt"}): TStringList;
  Var
    ErrorCode: Integer;
    HeaderData: THeaderData;
    HeaderDataEx: THeaderDataEx;
    #IfDef Unicode
    HeaderDataExW: THeaderDataExW;
    #EndIf
    File: String;
    Attr: longInt;
    Size: LongInt;
  Begin
    If ArcHandle <> 0 then
    begin
      Result := TStringList.Create;
      UnpackSize := 0;
      NumberOfFiles := 0;
      Repeat
        #IfDef Unicode
        Try
          ErrorCode := ReadHeaderExW(ArcHandle, HeaderDataExW);
        except
        #EndIf
          Try
            ErrorCode := ReadHeaderEx(ArcHandle, HeaderDataEx);
          except
            ErrorCode := ReadHeader(ArcHandle, HeaderData);
          end
        #IfDef Unicode
        end;
        #EndIf
        If ErrorCode = E_Success then
        begin
          #IfDef Unicode
          Try
            ErrorCode := ProcessFileW( ArcHandle, PK_SKIP, #0, #0 );
          except
          #EndIf
            ErrorCode := ProcessFile( ArcHandle, PK_SKIP, #0, #0 );
          #IfDef Unicode
          end;
          #EndIf

          #IfDef Unicode
          With HeaderDataExW do
          begin
            File := ArrayOfWideChar2String(FileName);
            If Length(File) > 0 then
            begin
              Attr := FileAttr;
              Size := UnpSize;
            end;
          end; // HeaderDataExW.
          #EndIf
          If Length(File) = 0 then
            With HeaderDataEx do
            begin
              File := ArrayOfAnsiChar2String(FileName);
              If Length(File) > 0 then
              begin
                Attr := FileAttr;
                Size := UnpSize;
              end;
            end; // HeaderDataEx.
          If Length(File) = 0 then
            With HeaderData do
            begin
              File := ArrayOfAnsiChar2String(FileName);
              If Length(File) > 0 then
              begin
                Attr := FileAttr;
                Size := UnpSize;
              end;
            end; // HeaderData.
          Result.Add( File );
          UnpackSize := UnpackSize + Size;
          if Attr and FA_Directory = FA_Directory then
            Inc(NumberOfDirs)
          else
            Inc(NumberOfFiles);
        end;
      Until ErrorCode <> E_Success;
      If SortFiles Then
        Result.Sort;
    End;
end;

Function WcxExtractArchive(Path: String): Boolean;
  Var
    ErrorCode: Integer;
    HeaderData: THeaderData;
    HeaderDataEx: THeaderDataEx;
    #IfDef Unicode
    HeaderDataExW: THeaderDataExW;
    #EndIf
    File: String;
    Attr: longInt;
  Begin
    Result := False;
    If ArcHandle <> 0 then
    begin
      Repeat
        #IfDef Unicode
        Try
          ErrorCode := ReadHeaderExW(ArcHandle, HeaderDataExW);
        except
        #EndIf
          Try
            ErrorCode := ReadHeaderEx(ArcHandle, HeaderDataEx);
          except
            ErrorCode := ReadHeader(ArcHandle, HeaderData);
          end;
        #IfDef Unicode
        end;
        #EndIf
        If ErrorCode = E_Success then
        begin
          #IfDef Unicode
          With HeaderDataExW do
          begin
            File := ArrayOfWideChar2String(FileName);
            If Length(File) > 0 then
              Attr := FileAttr;
          end; // HeaderDataExW.
          #EndIf
          If Length(File) = 0 then
            With HeaderDataEx do
            begin
              File := ArrayOfAnsiChar2String(FileName);
              If Length(File) > 0 then
                Attr := FileAttr;
            end; // HeaderDataEx.
          If Length(File) = 0 then
            With HeaderData do
            begin
              File := ArrayOfAnsiChar2String(FileName);
              If Length(File) > 0 then
                Attr := FileAttr;
            end; // HeaderData.
          ForceDirectories( AddBackSlash(Path) + ExtractFilePath(File) );
          if Attr and FA_Directory = FA_Directory then
          begin
            #IfDef Unicode
            Try
              ErrorCode := ProcessFileW( ArcHandle, PK_SKIP, #0, #0 );
            except
            #EndIf
              ErrorCode := ProcessFile( ArcHandle, PK_SKIP, #0, #0 );
            #IfDef Unicode
            end;
            #EndIf
          end
          else
          begin
            #IfDef Unicode
            Try
              ErrorCode := ProcessFileW( ArcHandle, PK_EXTRACT, '', AddBackSlash(Path) + File );
            except
            #EndIf
              ErrorCode := ProcessFile( ArcHandle, PK_EXTRACT, '', AddBackSlash(Path) + File );
            #IfDef Unicode
            end;
            #EndIf
            Result := ErrorCode = E_Success;
          end;
        end;
      Until ErrorCode <> E_Success;
    End;
end;

Function WcxShowOptions(): Boolean;
  Var
    ErrorCode: Integer;
    DllHandle: Thandle;
  Begin
    Result := False;
    if PackerCaps and PK_CAPS_OPTIONS = PK_CAPS_OPTIONS then
    begin
      DllHandle := LoadDLL( ExpandConstant('{tmp}\{#WcxDLL}'), ErrorCode );
      If DllHandle <> 0 then
      begin
        Try
          ConfigurePacker( WizardForm.Handle, DllHandle);
          Result := True;
        except
        end;
        FreeDLL(DllHandle);
      end;
    end;
end;

//[code]

Procedure ShowOptions(Sender: TObject);
  begin
    If not WcxShowOptions() then
      TButton(Sender).Free;
end;

Var
  InputOptionWizardPage: TInputOptionWizardPage;
  InputFileWizardPage: TInputFileWizardPage;
  OutputMsgMemoWizardPage: TOutputMsgMemoWizardPage;
  InputDirWizardPage: TInputDirWizardPage;

Procedure Browse4File(Sender: TObject);
  var
    FileName: String;
  begin
    If GetOpenFileName('Browse for {#RemoveFileExt(ExtractFileName(WcxDLL))}...', FileName, '', 'All files|*.*', '*.*') then
      InputFileWizardPage.Edits[0].Text := FileName;
end;

// This part of [code] was taken from there: https://stackoverflow.com/a/44248847
// with modification done by me
Function Browse4FolderEx(Directory: String): String;
  Var
    Int1: Integer;
  begin
    With CreateInputDirPage(wpFinished, '', '', '', False, '') do
    begin
      Int1 := Add('');
      Values[Int1] := Directory;
      Buttons[Int1].OnClick(Buttons[Int1]);
      Result := Values[Int1];
      Free;
    end;
end;

Procedure Browse4Folder(Sender: TObject);
  var
    DirName: String;
  begin
    With InputDirWizardPage.Edits[0] do
    begin
      DirName := Browse4FolderEx( ExtractFilePath(Text) );
      If Length(DirName) > 0 then
        Text := AddBackslash(DirName) + ChangeFileExt( ExtractFileName(InputFileWizardPage.Edits[0].Text), '' );
    end; // InputDirWizardPage.Edits[0].
end;

Procedure InitializeWizard();
  begin
    PackerCaps := GetPackerCaps();

    if PackerCaps and PK_CAPS_OPTIONS = PK_CAPS_OPTIONS then
      With TButton.Create( WizardForm ) do
      begin
        Parent := WizardForm;
        Top := WizardForm.NextButton.Top;
        Left := ScaleX(10);
        Width := WizardForm.NextButton.Width * 2;
        Height := WizardForm.NextButton.Height;
        Caption := 'Show packer Options';
        OnClick := @ShowOptions;
      End;

    InputOptionWizardPage := CreateInputOptionPage(wpInfoBefore, 'Select WCX mode.', 'Here you can select WCX mode.', 'Please select WCX mode you want to use.', True, False);
    with InputOptionWizardPage do
    begin
      if PackerCaps and PK_CAPS_MODIFY = PK_CAPS_MODIFY then
        Add('List / Extract (and Modify)')
      else
        Add('List / Extract');
(*
      if PackerCaps and PK_CAPS_NEW = PK_CAPS_NEW then
        Add('Create new archive');
*)
      Values[0] := True;
    end; // InputOptionWizardPage.
    InputFileWizardPage := CreateInputFilePage(InputOptionWizardPage.ID, 'Select file for WCX plugin.', 'Here you can select file to load into WCX.', 'Please select file to load into {#WcxDLL}.');
    With InputFileWizardPage do
      Buttons[Add('File location:', 'All files|*.*', '*.*')].OnClick := @Browse4File;
    OutputMsgMemoWizardPage := CreateOutputMsgMemoPage(InputFileWizardPage.ID, 'Archive content.', 'Here you will see the archive content.', 'This archive contains:', '');
    InputDirWizardPage := CreateInputDirPage(OutputMsgMemoWizardPage.ID, 'Select output location.', 'Here you can select where the files will be extracted/upacked.', 'Please select where the content of the archive can be located.', True, ExtractFileName(InputFileWizardPage.Edits[0].Text));
    With InputDirWizardPage do
      Buttons[Add('')].OnClick := @Browse4Folder;
end;

Var
  NumberOfFiles, NumberOfDirs: {#Defined Unicode ? "Int64" : "LongInt"};

#IfDef Unicode
// This part of [code] was taken from there: https://stackoverflow.com/a/32787518
// with small modification done by me
function GetFileSize64(FileName: String): Int64;
  var
    FindRec: TFindRec;
  begin
    if FindFirst(FileName, FindRec) then
    begin
      With FindRec do
        Result := Int64(SizeHigh) shl 32 + SizeLow;
      FindClose(FindRec);
    end
    else
      Result := -1;
end;
#EndIf

function NextButtonClick(CurPageID: Integer): Boolean;
  Var
    Int1, Int2: {#Defined Unicode ? "Int64" : "LongInt"};
  Begin
    Result := True;
    If CurPageID = InputFileWizardPage.ID then
      If FileExists( InputFileWizardPage.Values[0] ) then
      begin
        Int1 := CanYouOpenThisFile( InputFileWizardPage.Values[0] );
        if ( Int1 = -1 ) or ( Int1 = 1 ) then
          Result := WcxOpenArchive(InputFileWizardPage.Values[0], PK_OM_LIST)
        else
          Result := False;
        If Result then
        begin
          With OutputMsgMemoWizardPage do
          begin
            RichEditViewer.RTFText := WcxListArchive(False, Int1, NumberOfFiles, NumberOfDirs).Text;
            SubCaptionLabel.Caption := 'This archive contains ' + IntToStr(NumberOfDirs) + ' Folders and ' + IntToStr(NumberOfFiles) + ' Files:';
            if Int1 > 0 Then
            #IfDef Unicode
            begin
              Int2 := GetFileSize64(InputFileWizardPage.Values[0]);
            #Else
              If FileSize(InputFileWizardPage.Values[0], Int2) then
            #EndIf
                SubCaptionLabel.Caption := 'Archive ratio: ' + {#Defined Unicode ? "Format('%.2f', [Single(Int2)" : "IntToStr(Int2"} * 100 / Int1{#Defined Unicode ? "]" : ""}) + '%. ' + SubCaptionLabel.Caption;
            #IfDef Unicode
            end;
            #EndIf
          end; // OutputMsgMemoWizardPage.
        end
        else
          MsgBox('Please select another file, this file can''t be used with this WCX plugin.', mbError, MB_OK);
        If ArcHandle <> 0 then
          If CloseArchive(ArcHandle) = E_Success then
            ArcHandle := 0;
      End
      else
      begin
        Result := False;
        MsgBox('Please select any file.', mbError, MB_OK);
      end;
end;

Var
  FilesExtracted: Integer;

function ProcessDataProc(FileName: PAnsiChar; Size: longInt): longInt;
  Begin
    Result := 1;
    With WizardForm do
    begin
      StatusLabel.Caption := 'Extracting: ' + ExtractFileName(FileName);
      FilenameLabel.Caption := ExtractFilePath(FileName);
      If ( NumberOfFiles >= FilesExtracted ) then
      begin
        ProgressGauge.Position := FilesExtracted * 100 / NumberOfFiles;
        Inc(FilesExtracted);
      end;
    end; // WizardForm.
end;

#IfDef Unicode
function ProcessDataProcW(FileName: String; Size: longInt): longInt;
  Begin
    Result := ProcessDataProc( PAnsiChar(FileName), Size );
end;
#EndIf

#If Ver < 0x06000000
Type
  ExtractCallBackProc = function(FileName: PAnsiChar; Size: longInt): longInt;
  #IfDef Unicode
  ExtractCallBackProcW = function(FileName: String; Size: longInt): longInt;
  #EndIf
  function WrapExtractDataProc(callback: ExtractCallBackProc; paramcount: integer): longword;
    external 'wrapcallbackaddr@files:CallbackCtrl.dll stdcall delayload';
  #IfDef Unicode
  function WrapExtractDataProcW(callback: ExtractCallBackProcW; paramcount: integer): longword;
    external 'wrapcallbackaddr@files:CallbackCtrl.dll stdcall delayload';
  #EndIf
#EndIf

procedure CurStepChanged(CurStep: TSetupStep);
  Var
    ExtractCallBack: LongWord;
    #IfDef Unicode
    ExtractCallBackW: LongWord;
    #EndIf
  Begin
    if CurStep = ssInstall then
      If WcxOpenArchive(InputFileWizardPage.Values[0], PK_OM_EXTRACT) then
      begin
        #If Ver < 0x06000000
          #IfDef Unicode
        ExtractCallBackW := WrapExtractDataProcW(@ProcessDataProcW, 2);
          #EndIf
        ExtractCallBack := WrapExtractDataProc(@ProcessDataProc, 2);
        #Else
          #IfDef Unicode
        ExtractCallBackW := CreateCallback(@ProcessDataProcW);
          #EndIf
        ExtractCallBack := CreateCallback(@ProcessDataProc);
        #EndIf
        #IfDef Unicode
        Try
          SetProcessDataProcW( ArcHandle, ExtractCallBackW );
        except
        #EndIf
          SetProcessDataProc( ArcHandle, ExtractCallBack );
        #IfDef Unicode
        end;
        #EndIf
        With WizardForm.ProgressGauge do
        begin
          Min := 0;
          Max := 100;
        end; // WizardForm.ProgressGauge.
        WcxExtractArchive( InputDirWizardPage.Values[0] );
        #IfDef Unicode
        Try
          SetProcessDataProcW( ArcHandle, 0 );
        except
        #EndIf
          SetProcessDataProc( ArcHandle, 0 );
        #IfDef Unicode
        end;
        #EndIf
        #If Ver < 0x06000000
(*
          ExtractCallBack := WrapExtractDataProc(nil, 0);
          #IfDef Unicode
          ExtractCallBackW := WrapExtractDataProc(nil, 0);
          #EndIf
*)
        #EndIf
        ExtractCallBack := 0;
        #IfDef Unicode
        ExtractCallBackW := 0;
        #EndIf
        If CloseArchive(ArcHandle) = E_Success then
          ArcHandle := 0;
      end;
end;

Procedure DeinitializeSetup();
  begin
    If ArcHandle <> 0 then
      CloseArchive(ArcHandle);
    UnloadDLL( ExpandConstant('{tmp}\{#WcxDLL}') );
end;
