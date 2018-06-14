pro get_visit42_angle
	; throw away program to check Niriss to fgs angle

	s=[[1.052966660,0.546825116,1.04640,0.559300],$
		[-0.545313831,0.894839629,-0.555900,0.888300],$
		[-0.986008788,-0.416011939,-0.981000,-0.427700],$
		[-0.0479320861,-1.28261660,-0.0327000,-1.28310],$
		[1.052966670,0.546825120,1.04640,0.559300],$
		[-0.545313826,0.894839635,-0.555900,0.888300],$
		[-0.986008790,-0.416011942,-0.981000,-0.427700]]

	xIdl=s[0,*]
	yIdl=s[1,*]
	sx=s[2,*]
	sy=s[3,*]

	forprint,xIDL,yIDL,sx,sy
	print,'----'
	a=findgen(20)*0.1-2
	ra=a*!dtor

	VIdlParity=+1.0

	xFGSRef=(yFGSRef=0.0)
	a=-1.250800+0.569986
	ra=a*!dtor
	for i=0,n_elements(xIdl)-1 do begin
		xFGS = xFGSRef + (VIdlParity*xIdl[i] * cos(ra)) + (yIdl[i] * sin(ra))
		yFGS = yFGSRef - (VIdlParity*xIdl[i] * sin(ra)) + (yIdl[i] * cos(ra))
		print,xIdl[i],yIdl[i],xFGS,yFGS,sx[i],sy[i],xFGS-sx[i],yFGS-sy[i]
	endfor

	stop
end
