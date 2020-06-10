Declare @SoftwareName varchar (255)
Set@SoftwareName ='%Microsoft SQL Server%'

Select
distinct vrs.Name0,
vrs.User_Name0,vga.DisplayName0,vga.InstallDate0,vga.Publisher0,vga.ProdID0fromv_R_System asVrsinner joinv_GS_ADD_REMOVE_PROGRAMS_64 asVga onVrs.ResourceID=Vga.ResourceIDwhereVga.DisplayName0 like@SoftwareNameandvga.Publisher0 isnotnull
