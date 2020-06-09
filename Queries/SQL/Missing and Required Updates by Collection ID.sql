select CAST(DATEPART(yyyy,ui.DatePosted) AS varchar(255)) + '-' + RIGHT('0' + CAST(DATEPART(mm, ui.DatePosted) AS VARCHAR(255)), 2) AS MonthPosted,
ui.bulletinid [BulletinID],ui.articleid [ArticleID], ui.Title,
    Targeted=(case when ctm.ResourceID is not null then '*' else '' end),
    IsRequired=(case when css.Status=2 then '*' else '' end),
    ui.InfoURL as InformationURL,
    ui.dateposted [Date Posted] ,
    Deadline=cdl.Deadline
    from V_UpdateComplianceStatus  css
    join v_UpdateInfo ui on ui.CI_ID=css.CI_ID
    left join v_CITargetedMachines  ctm on ctm.CI_ID=css.CI_ID and ctm.ResourceID = css.ResourceID
    INNER join v_CICategories_All catall2 on catall2.CI_ID=css.CI_ID
    INNER  join v_CategoryInfo catinfo2 on catall2.CategoryInstance_UniqueID = catinfo2.CategoryInstance_UniqueID
    and catinfo2.CategoryTypeName='UpdateClassification'
    JOIN dbo.v_R_System AS vrs ON vrs.ResourceID = css.ResourceID
       outer apply (
       select Deadline=min(a.EnforcementDeadline)
       from v_CIAssignment  a
       join v_CIAssignmentToCI atc on atc.AssignmentID=a.AssignmentID and atc.CI_ID=css.CI_ID
       ) cdl
   -- CHANGE COLLECTION ID BEFORE RUNNING!
   WHERE vrs.Name0='SESCADADC02' and
   ui.Severity IN (8) --this is for security and critical updates
  AND css.Status=2  --for required
