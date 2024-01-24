USE [si_solm_2021]
GO
/****** Object:  StoredProcedure [dbo].[USP_NOTIFICACION_IBP_X_VENCER]    Script Date: 23/04/2021 12:54:54 p.m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Max
-- Create date: 2020/07/28
-- Description:	<Description,,>
-- =============================================
--EXEC DBO.USP_NOTIFICACION_IBP_X_VENCER '03','1'
--EXEC DBO.USP_NOTIFICACION_IBP_X_VENCER '03','2'

--SET @TIPO_CORREO=1	notificacion
--SET @TIPO_CORREO=2	recordatorio

ALTER PROCEDURE[dbo].[USP_NOTIFICACION_IBP_X_VENCER](@PERS_TIPOTRAB VARCHAR(2), @TIPO_CORREO INT)
AS
BEGIN

	DECLARE @CODIGO_SUCU VARCHAR(2), @AUX INT, @AUX2 INT, @I INT,
			@ADMINISTRADOR VARCHAR(300), @ASUNTO VARCHAR(300), @SUCURSAL_NOMBRE VARCHAR(50), @PERIODO VARCHAR(50), 
			@CORREO_ADMI VARCHAR(300), @CORREO_JEOPE VARCHAR(300), @CORREOS_CC VARCHAR(800), @MENSAJE VARCHAR(1000)

	DECLARE @FECHA DATETIME, @JEFERRHH VARCHAR(300), @USUARIO VARCHAR(50), @ETIQUETA VARCHAR(50), 
			@TITULO VARCHAR(50), @BANNER VARCHAR(100), @VIGENCIA_PERS VARCHAR(2), @DIRECTORIO VARCHAR(MAX)
	
	IF @TIPO_CORREO = 1 -- notificación (está por vencer)
		BEGIN
			SET @FECHA =  CAST(CONVERT(CHAR(10), DATEADD(DAY,(30), GETDATE()), 103) AS DATETIME)
			--SET @FECHA = CAST(CONVERT(CHAR(10), DATEADD(DAY,(30), '11/12/2022'), 103) AS DATETIME)
			/*Suma a la fecha actual 30 días. Por ejemplo:
				GETDATE() = '2021-04-24' 
				@FECHA = '2021-05-24 00:00:00'
				NOTA: Si sale el error de... out-of-range value.
				colocar antes de asignar el SET @FECHA 
				SET DATEFORMAT dmy
				Esto por que el 103 convierte las fechas en el formato d/m/y
				por lo tanto debemos decirle que usaremos ese formato
			*/
			SET @VIGENCIA_PERS ='SI'			
		END 
	ELSE IF @TIPO_CORREO = 2 -- recordatorio (ya venció)
		BEGIN
			SET @FECHA = CAST(CONVERT(CHAR(10), DATEADD(DAY,(-1), GETDATE()), 103) AS DATETIME)
			 --SET @FECHA = CAST(CONVERT(CHAR(10), DATEADD(DAY,(29), '12/12/2022'), 103) AS DATETIME)
			SET @VIGENCIA_PERS ='NO'
		END
		--SELECT 	@JEFERRHH =  dbo.F_PRIMERA_LETRA_MAYUSCULA(P.NOMB_1)+' '+P.APEL_1+' '+ dbo.F_PRIMERA_LETRA_MAYUSCULA(P.APEL_2)
		--FROM Intranet.dbo.JEOSIS_Libreta_Direcciones_SOLMAR LD
		--INNER JOIN si_solm.dbo.PERSONAL P  ON P.codi_pers = LD.codi_pers collate SQL_Latin1_General_CP1_CI_AS
		--WHERE lds_correo = 'rrhh@gruposolmar.com.pe'  and isnull(lds_correo_principal,0) = 1 ;
	DECLARE @TABLA TABLE(IT INT IDENTITY(1,1), CODI_SUCU VARCHAR(2), EMPRESA VARCHAR(100), SUCURSAL VARCHAR(40),
						 TIPO VARCHAR(20), CODIPERS CHAR(5), NOMBRES VARCHAR(150), DNI VARCHAR(15), CARGO VARCHAR(150),
						 CERT_FECHA_EMISION CHAR(10), FECH_INGRE_PLANILLA CHAR(10), FECHAINI CHAR(10), FECHAFIN CHAR(10),
						 CLIENTE VARCHAR(100), USUA_REG VARCHAR(50), CERT_VIGENCIA VARCHAR(50), SUCU_ABREVIATURA VARCHAR(30))
	INSERT INTO @TABLA
	SELECT	P.SUCU_CODIGO, 
			(SELECT RAZON_SOCIAL FROM EMPRESA WHERE P.EMPR_CODIGO = EMPR_CODIGO) EMPRESA,						
			(SELECT SUCU_ABREVIATURA FROM SISO_SUCURSAL WHERE SUCU_CODIGO = P.SUCU_CODIGO) SUCURSAL,
			(SELECT TIPE_DESCRIPCION FROM ADMI_TIPO_PERSONAL WHERE P.PERS_TIPOTRAB = TIPE_CODIGO) TIPO,
			P.CODI_PERS,						
			upper(substring(P.APEL_1, 1,1))+lower(substring(P.APEL_1,2,LEN(P.APEL_1)-1))+' ' +upper(substring(isnull(P.APEL_2,''),1, 1))+lower(substring(isnull(P.APEL_2,''),2,20)) + ' '+upper(substring(P.NOMB_1, 1, 1))+lower(substring(P.NOMB_1, 2,LEN(P.NOMB_1)-1)) AS NOMBRES,
			P.NRO_DOCU_IDEN,
			UPPER(LEFT(CA.DESC_CARGO, 1)) + LOWER(SUBSTRING(CA.DESC_CARGO, 2, LEN(CA.DESC_CARGO))) AS CARGO,
			CONVERT(VARCHAR(10),R.CERT_FECHA_EMISION, 103),
			CONVERT(VARCHAR(10),P.FECH_INGRE_PLANILLA, 103),
			CONVERT(VARCHAR(10),FECH_INIC_CONT, 103),
			CONVERT(VARCHAR(10),FECH_FIN_CONT, 103),	
			(SELECT DENOMINACION FROM CLIENTE_PROVEEDOR WHERE CODI_CLIE_PROV = C.CODI_CLIE_PROV) AS CLIENTE
			,USUA_REG
			,R.CERT_VIGENCIA
			,S.SUCU_ABREVIATURA
	FROM CONTRATOS_PERSONAL C 
		INNER JOIN PERSONAL P ON P.CODI_PERS = C.CODI_PERS
		INNER JOIN CARGOS CA ON C.CODI_CARG = CA.CODI_CARG
		INNER JOIN REDO_CERTIFICADO R ON P.CODI_PERS = R.CODI_PERS
		INNER JOIN SISO_SUCURSAL S ON P.SUCU_CODIGO=S.SUCU_CODIGO
	WHERE CONT_VIGENCIA = 'SI' 
		AND ESTA_CONT = 1
		AND PERS_VIGENCIA = 'SI'
		--AND CA.CARG_VIGENCIA = 'SI'
		AND CAST(CONVERT(VARCHAR,CERT_FECHA_CADUCA,103) AS DATETIME) = @FECHA
		AND (@PERS_TIPOTRAB = '03' AND P.PERS_TIPOTRAB IN ('01', '03','05') OR (P.PERS_TIPOTRAB = @PERS_TIPOTRAB) OR (@PERS_TIPOTRAB = 'T'))      
		AND R.REQU_CODIGO = 81
		AND CERT_VIGENCIA IN (SELECT TOP 1 RE.CERT_VIGENCIA 
							  FROM REDO_CERTIFICADO RE 
							  WHERE RE.REQU_CODIGO = 81 AND RE.CODI_PERS = R.CODI_PERS  AND RE.CERT_VIGENCIA = @VIGENCIA_PERS 
							  ORDER BY RE.CERT_CODIGO DESC)
	ORDER BY  NOMBRES

	--SELECT * FROM @TABLA	
	SELECT @AUX2 = COUNT(*) FROM @TABLA	

	IF @AUX2 > 0 
		BEGIN
			DECLARE @ADMIN TABLE(ID INT IDENTITY(1,1), CODIGO VARCHAR(5), NOMBRES VARCHAR(300), NUMDOCU VARCHAR(10), CARGO VARCHAR(150), 
							 ETIQUETA VARCHAR(150), CORREO VARCHAR(150),  CORREO_ADMI varchar(500),LOGIN varchar(20))
			INSERT INTO @ADMIN
			SELECT	P.CODI_PERS,
					CASE P.PERS_SEXO WHEN 'M' THEN 'Sr. ' ELSE 'Srta. ' END + (upper(substring(P.NOMB_1, 1, 1))+lower(substring(P.NOMB_1, 2,LEN(P.NOMB_1)-1))+' '+upper(substring(P.APEL_1, 1,1))+lower(substring(P.APEL_1,2,LEN(P.APEL_1)-1))+' ' +upper(substring(P.APEL_2,1, 1))+lower(substring(P.APEL_2,2,20))) +'<br> ' AS NOMBRES
					,P.NRO_DOCU_IDEN AS NUMDOCU
					,UPPER(LEFT(CA.DESC_CARGO, 1)) + LOWER(SUBSTRING(CA.DESC_CARGO, 2, LEN(CA.DESC_CARGO))) AS CARGO						
					,(SELECT TOP 1 ISNULL(L.LDS_ETIQUETA,'') FROM INTRANET.[DBO].JEOSIS_Libreta_Direcciones_SOLMAR AS L WHERE L.LDS_ESTADO = 'A'  AND  L.CODI_PERS =P.CODI_PERS  COLLATE Modern_Spanish_CS_AS ) AS ETIQUETA
					,(SELECT TOP 1 ' <'+ISNULL(L.LDS_CORREO,'')+'>' FROM INTRANET.[DBO].JEOSIS_Libreta_Direcciones_SOLMAR AS L WHERE L.LDS_ESTADO = 'A'  AND  L.CODI_PERS =P.CODI_PERS  COLLATE Modern_Spanish_CS_AS ) AS CORREO
					,(SELECT TOP 1 ISNULL(L.LDS_ETIQUETA,'')+' <'+ISNULL(L.LDS_CORREO,'')+'>' FROM INTRANET.[DBO].JEOSIS_Libreta_Direcciones_SOLMAR AS L WHERE L.LDS_ESTADO = 'A'  AND  L.CODI_PERS =P.CODI_PERS  COLLATE Modern_Spanish_CS_AS ) AS CORREO_ADMI
					,u.login
			FROM PERSONAL P 
				INNER JOIN CARGOS CA ON P.CODI_CARG = CA.CODI_CARG	
				INNER JOIN USUARIOS U ON P.CODI_PERS=U.CODI_PERS
			WHERE P.codi_pers IN(09852)
			ORDER BY SUCU_CODIGO
					
			DECLARE @tableHTML  NVARCHAR(MAX) 
			SELECT @AUX = COUNT(*) FROM @ADMIN
			SET @I = 1
			
			WHILE @AUX >= @I 
				BEGIN
					DECLARE @SUCU_CODIGO VARCHAR(2), @CANTIDAD_C INT
					--SET @CORREO_ADMI= ''
					SET	@ADMINISTRADOR=(SELECT NOMBRES FROM @ADMIN WHERE ID=@I)
					SET @ETIQUETA=(SELECT ETIQUETA FROM @ADMIN WHERE ID=@I)
					SET @USUARIO=(SELECT LOGIN FROM @ADMIN WHERE ID=@I)
					SET @CORREO_ADMI=(SELECT CORREO_ADMI FROM @ADMIN WHERE ID=@I)
           
					SELECT @CANTIDAD_C = COUNT(*) FROM @TABLA WHERE CERT_VIGENCIA = @VIGENCIA_PERS

					IF @TIPO_CORREO = 1 
						BEGIN
							SET @BANNER='RRHH_IBP_PROXIMO_VENCER.jpg'
							SET @MENSAJE = 'Se le informa  que hay '+CAST(@CANTIDAD_C AS VARCHAR)+' Certificados  IBP PRÓXIMOS A VENCER  por lo que se le exhorta a tomar las medidas necesarias.'
							SET @ASUNTO = 'IBP PRÓXIMOS A VENCER'---cambio mx
							SET @TITULO ='PERSONAL CON IBP PRÓXIMO A VENCER'
							SET @DIRECTORIO ='\\192.168.10.2\Biblioteca_Grafica\TEXTO\Firma\SECURITY_1.png;\\192.168.10.2\Biblioteca_Grafica\TEXTO\Firma\SECURITY_2.png;\\192.168.10.2\Biblioteca_Grafica\TEXTO\Firma\solmar3.gif;\\192.168.10.2\Biblioteca_Grafica\TEXTO\Firma\RRHH_IBP_PROXIMO_VENCER.jpg'
						END 
					ELSE IF @TIPO_CORREO = 2 
						BEGIN
							SET @BANNER='RRHH_IBP_VENCIDO.jpg'	
							SET @MENSAJE = 'Se le informa  que hay '+CAST(@CANTIDAD_C AS VARCHAR)+' Certificados  IBP VENCIDOS  por lo que se le exhorta a tomar las medidas necesarias.'
							SET @ASUNTO = 'IBP VENCIDOS'
							SET @TITULO ='PERSONAL CON IBP VENCIDO'
							SET @DIRECTORIO ='\\192.168.10.2\Biblioteca_Grafica\TEXTO\Firma\SECURITY_1.png;\\192.168.10.2\Biblioteca_Grafica\TEXTO\Firma\SECURITY_2.png;\\192.168.10.2\Biblioteca_Grafica\TEXTO\Firma\solmar3.gif;\\192.168.10.2\Biblioteca_Grafica\TEXTO\Firma\RRHH_IBP_VENCIDO.jpg'
						END

                        --COPIAS
                        
                        --SOLMAR Comercial <comercial@gruposolmar.com.pe>; 
                        --SOLMAR Planillas Corporativas <planillascor@gruposolmar.com.pe>;
                        -- SOLMAR Legal <legal@gruposolmar.com.pe>;
                        -- SOLMAR Recursos Humanos <rrhh@gruposolmar.com.pe>;462
                        -- Miguel VIVANCO <miguelvivanco@gruposolmar.com.pe>; 449
                        --SOLMAR Finanzas <finanzas@gruposolmar.com.pe>; 
                        --SOLMAR Logística <logistica@gruposolmar.com.pe>; 
                        --SOLMAR Contabilidad <contabilidad@gruposolmar.com.pe>;
                        --SOLMAR Operaciones  <operaciones@gruposolmar.com.pe>; 
                        --SOLMAR "Seguros de su Seguridad" <solmar@gruposolmar.com.pe>; 501
                        --SOLMAR Servicio Social <serviciosocial@gruposolmar.com.pe>;
                        
                        -- SOLMAR File Control <filecontrol@gruposolmar.com.pe>;582
                        -- SOLMAR Servicios Generales <serviciosgenerales@gruposolmar.com.pe>; 634
					DECLARE  @AUXCORREO VARCHAR(2)

					SELECT @AUXCORREO = COUNT(*) 
					FROM  Intranet.[dbo].[JEOSIS_Libreta_Direcciones_SOLMAR]
					WHERE lds_id in ('449','462','501','582')
						
					DECLARE  @LoopCounter int
					DECLARE  @MaxEmployeeId  int
					DECLARE  @l_correo NVARCHAR(800)
					DECLARE  @L_CORREOS varchar (200)
					
					DECLARE @TABLACORREO TABLE(lds_id INT IDENTITY(1, 1),lds_correos VARCHAR(200))
					
					INSERT INTO @TABLACORREO
					SELECT  lds_etiqueta +' '+'<'+  lds_correo + '>; ' AS Nombres 
					FROM  Intranet.[dbo].[JEOSIS_Libreta_Direcciones_SOLMAR]
					WHERE lds_id in ('449','462','501','582')

					SET @LoopCounter = 1
					SET @MaxEmployeeId = @AUXCORREO
					set @l_correo = ''
				
					WHILE(@LoopCounter <= @MaxEmployeeId)
						BEGIN
							SELECT @l_correo = @l_correo + lds_correos
							FROM  @TABLACORREO 
							WHERE lds_id = @LoopCounter
							
							SET @LoopCounter  = @LoopCounter  + 1 					
						END
					

					SET @CORREOS_CC = @l_correo +' '+'SOLMAR Administracion <administracion@gruposolmar.com.pe>;SOLMAR Control Administrativo <controladmon@gruposolmar.com.pe>'
					--SET @CORREOS_CC = 'SOLMAR Sisolmar  <sisolmar@gruposolmar.com.pe>;'+@CORREO_JEOPE
			
					--CONDICION CUANDO TENGA REGISTROS.
					IF @CANTIDAD_C > 0 
						BEGIN
							IF @TIPO_CORREO = 1 
								BEGIN
									SET @tableHTML =
										N'<html><body text="#002060"><table border = "0"  width="800" align = "left" style="border-collapse:collapse; font-family:arial;font-size:11px;"><tr><td>' +
										N'<table border="1" cellpadding = "2" width="800" align ="left" style="border-collapse:collapse;font-family:arial;font-size:11px;" bordercolor="#1f497d">' +
										N'<tr><td colspan="11" align="center" ><img src="'+@BANNER+'" width="800" ></td></tr>' +
										N'<tr style="text-align: justify;"><td colspan="11"style="LINE-HEIGHT:15px; font-size:12px; padding-left: 12px; padding-right: 12px;"><strong><br>' +@ADMINISTRADOR+@ETIQUETA+'</strong><br><br>'+@MENSAJE +'<br><br>'+	
										N'<tr BGCOLOR = "#1f497d"><th colspan="11"><font color="#ffffff">'+@TITULO+' </font></th></tr>' +
										N'<tr><th>IT</th><th>CÓDIGO</th><th>APELLIDOS Y NOMBRES</th><th>DOC.<BR>IDENTIDAD</th><th>CARGO</th><th>FECHA EMISIÓN IBP </th><th>INGRESO A<BR>PLANILLAS</th><th>INICIO<BR>CONTRATO</th><th>TERMINO<BR>CONTRATO</th><th>CLIENTE</th><th>SUCURSAL</th></tr>' +
										CAST (( SELECT "td/@align"	= 'center',	td = ROW_NUMBER() OVER(ORDER BY NOMBRES), '',
													"td/@align" = 'center',	td = CODIPERS, '',
													"td/@align" = 'left', td = NOMBRES, '',
													"td/@align" = 'center', td = DNI, '',
													"td/@align" = 'center', td = CARGO, '',
													"td/@align" = 'center', td = CERT_FECHA_EMISION, '',
													"td/@align" = 'center', td = FECH_INGRE_PLANILLA, '',
													"td/@align" = 'center', td = FECHAINI, '',
													"td/@align" = 'center', td = FECHAFIN, '',	
													"td/@align" = 'left', td = CLIENTE, '',
													"td/@align" = 'left', td = SUCU_ABREVIATURA, ''
												FROM @TABLA
												--WHERE USUA_REG=@USUARIO
												ORDER BY 	NOMBRES	 
												FOR XML PATH('tr'), TYPE 
										) AS NVARCHAR(MAX) ) +
										N'</table>' +	
										'<br>' +
										'<br>' +
										'<br>' +
										'<br>' +
										'<br>' +
										'<br>' +
										'<br>' +
										'<br>' +
										'<br>' +
										'<br>' +
										'<p style="font-size:14px; font-family:Calibri;"><strong>Atentamente,</strong></p>' +
												'<table style="background-color:#FFFFFF;"> <strong>' +
												'<tr>' +
												'<td colspan="1" style="text-align:left">' +
												'<img src="SECURITY_1.png" width="110" alt="SOLMAR">' +
												'</td>' +
												'<td style="padding-left:20px; width:640px; font-size:14px;text-align:left; font-family:Calibri;">' +
												+'Sistema Integrado SOLMAR – SISOLMAR' +'<br>Módulo de Notificaciones<br>' +
												'<a href="mailto:robotsisolmar@gruposolmar.com.pe" target="_blank">robotsisolmar@gruposolmar.com.pe</a>' +								
												'</td>' +
												'</tr>' +
												'<tr>' +
												'<td colspan="2">' +
												'<img src="SECURITY_2.png" height="64" alt="SOLMAR2">' +
												'</tr>' +
												'<tr><td colspan="2" style="font-size:12px; font-family:Calibri;">' +
												'<font color="008000"><em>Piensa en el futuro del planeta, no imprimas este mensaje</em></font>' +
												'<img src="cid:solmar3.gif" alt="SOLMAR3"><strong></strong><br><strong>' +
												'<em>Ayúdanos a mejorar, si tienes comentarios, sugerencias o reclamos de  nuestros servicios, escríbenos a: </em></strong>' +
												'<strong><em><u><a href="mailto:hseq@gruposolmar.com.pe" target="_blank">hseq@gruposolmar.com.pe</a></u></em></strong>' +
												'</td></tr></strong>' +
												'</table></body></html>'
								END 
							ELSE IF @TIPO_CORREO = 2 
								BEGIN
									SET @tableHTML =
										N'<html><body text="#002060"><table border = "0"  width="800" align = "left" style="border-collapse:collapse; font-family:arial;font-size:11px;"><tr><td>' +
										N'<table border="1" cellpadding = "2" width="800" align ="left" style="border-collapse:collapse;font-family:arial;font-size:11px;" bordercolor="#1f497d">' +
										N'<tr><td colspan="11" align="center" ><img src="'+@BANNER+'" width="800" ></td></tr>' +
										N'<tr style="text-align: justify;"><td colspan="11"style="LINE-HEIGHT:15px; font-size:12px; padding-left: 12px; padding-right: 12px;"><strong><br>' +@ADMINISTRADOR+@ETIQUETA+'</strong><br><br>'+@MENSAJE +'<br><br>'+	
										N'<tr BGCOLOR = "#1f497d"><th colspan="11"><font color="#ffffff">'+@TITULO+' </font></th></tr>' +
										N'<tr><th>IT</th><th>CÓDIGO</th><th>APELLIDOS Y NOMBRES</th><th>DOC.<BR>IDENTIDAD</th><th>CARGO</th><th>FECHA EMISIÓN IBP </th><th>INGRESO A<BR>PLANILLAS</th><th>INICIO<BR>CONTRATO</th><th>TERMINO<BR>CONTRATO</th><th>CLIENTE</th><th>SUCURSAL</th></tr>' +
										CAST (( SELECT "td/@align"	= 'center',	td = ROW_NUMBER() OVER(ORDER BY NOMBRES), '',
													"td/@align" = 'center',	td = CODIPERS, '',
													"td/@align" = 'left', td = NOMBRES, '',
													"td/@align" = 'center', td = DNI, '',
													"td/@align" = 'center', td = CARGO, '',
													"td/@align" = 'center', td = CERT_FECHA_EMISION, '',
													"td/@align" = 'center', td = FECH_INGRE_PLANILLA, '',
													"td/@align" = 'center', td = FECHAINI, '',
													"td/@align" = 'center', td = FECHAFIN, '',	
													"td/@align" = 'left', td = CLIENTE, '',
													"td/@align" = 'left', td = SUCU_ABREVIATURA, ''
												FROM @TABLA
												--WHERE USUA_REG=@USUARIO
												ORDER BY 	NOMBRES	 
												FOR XML PATH('tr'), TYPE 
										) AS NVARCHAR(MAX) ) +
										N'</table>' +	
										'<br>' +
										'<br>' +
										'<br>' +
										'<br>' +
										'<br>' +
										'<br>' +
										'<br>' +
										'<br>' +
										'<br>' +
										'<br>' +
										'<p style="font-size:14px; font-family:Calibri;"><strong>Atentamente,</strong></p>' +
												'<table style="background-color:#FFFFFF;"> <strong>' +
												'<tr>' +
												'<td colspan="1" style="text-align:left">' +
												'<img src="SECURITY_1.png" width="110" alt="SOLMAR">' +
												'</td>' +
												'<td style="padding-left:20px; width:640px; font-size:14px;text-align:left; font-family:Calibri;">' +
												+'Sistema Integrado SOLMAR – SISOLMAR' +'<br>Módulo de Notificaciones<br>' +
												'<a href="mailto:robotsisolmar@gruposolmar.com.pe" target="_blank">robotsisolmar@gruposolmar.com.pe</a>' +								
												'</td>' +
												'</tr>' +
												'<tr>' +
												'<td colspan="2">' +
												'<img src="SECURITY_2.png" height="64" alt="SOLMAR2">' +
												'</tr>' +
												'<tr><td colspan="2" style="font-size:12px; font-family:Calibri;">' +
												'<font color="008000"><em>Piensa en el futuro del planeta, no imprimas este mensaje</em></font>' +
												'<img src="cid:solmar3.gif" alt="SOLMAR3"><strong></strong><br><strong>' +
												'<em>Ayúdanos a mejorar, si tienes comentarios, sugerencias o reclamos de  nuestros servicios, escríbenos a: </em></strong>' +
												'<strong><em><u><a href="mailto:hseq@gruposolmar.com.pe" target="_blank">hseq@gruposolmar.com.pe</a></u></em></strong>' +
												'</td></tr></strong>' +
												'</table></body></html>'

								END

							EXEC msdb.dbo.sp_send_dbmail 
							@profile_name	= 'sisolmar_notificaciones',
							--@recipients  = 'SOLMAR Sisolmar  <sisolmar@gruposolmar.com.pe>',
							@recipients		= 'SOLMAR Servicios Generales <serviciosgenerales@gruposolmar.com.pe>',			
							@copy_recipients = @CORREOS_CC,
							@blind_copy_recipients = 'SOLMAR Sistemas <sistemas@gruposolmar.com.pe>;SOLMAR Proyectos SW <proyectossw@gruposolmar.com.pe>; SOLMAR SW Training <swtraining@gruposolmar.com.pe> ;SOLMAR Sisolmar <sisolmar@gruposolmar.com.pe>',
							@subject = @ASUNTO,
							@body = @tableHTML,
							@importance ='HIGH',
							@body_format = 'HTML',
							@file_attachments= @DIRECTORIO

						END -- IF

					SET @I = @I + 1

				END   --WHILE
		END--IF @AUX2 >0
END

--SELECT * FROM REDO_CERTIFICADO WHERE REQU_CODIGO =81 AND PERS_TRABAJA ='F'
--SELECT * FROM IBP_DELITO WHERE CODI_PERS ='43427'
--SELECT * FROM  Intranet.[dbo].[JEOSIS_Libreta_Direcciones_SOLMAR]
--where lds_correo in('rrhh@gruposolmar.com.pe','planillascor@gruposolmar.com.pe','serviciosocial@gruposolmar.com.pe','miguelvivanco@gruposolmar.com.pe',
--'administracion@gruposolmar.com.pe','comercial@gruposolmar.com.pe','finanzas@gruposolmar.com.pe','logistica@gruposolmar.com.pe','contabilidad@gruposolmar.com.pe',
--'operaciones@gruposolmar.com.pe','solmar@gruposolmar.com.pe','legal@gruposolmar.com.pe','rrhh@gruposolmar.com.pe','filecontrol@gruposolmar.com.pe','serviciosgenerales@gruposolmar.com.pe'
--)
--SELECT * FROM REDO_REQUISITOS
--SELECT * FROM SISO_PARAMETRO
--WHERE PARA_DESCRIPCION LIKE '%IBP%'
--select * from segu_opcion where  opci_codigo='0311060800'

	--SELECT * FROM REDO_CERTIFICADO WHERE REQU_CODIGO =81 AND CERT_VIGENCIA ='NO'