uses
crt,sockets,windows,sysutils;
var
udpserversocket:longint;
ip:string;
server_addr,client_addr:tinetsockaddr;
tid:longword;
buf:array[0..2048]of char;
i:integer;
c:char;
procedure recv(psocket:pointer);
stdcall;
 var
 buffer:array[0..1024] of byte;
 socket:^longint;
 len:integer;
 remsg:pchar;
 iaddr:longint;
 i2:integer;
 begin
 socket:=psocket;
 remsg:=pchar(@buffer);
 while true do
 begin;
 iaddr:=sizeof(client_addr);
 len:=fprecvfrom(socket^,@buffer,1024,0,@client_addr,@iaddr);
  if len>0 then
  begin;
  buffer[len]:=0;
  gotoxy(1,wherey-1);
  insline;
  insline;
   for i2:=1 to length(remsg) div (windmaxx-windminx+1) do
   insline;
  writeln('�Է���');
  writeln(remsg);
  gotoxy(i+2,wherey+1+length(remsg) div (windmaxx-windminx+1));
   if i+2>=windmaxy then
   begin;
   writeln;
   gotoxy(windmaxx,wherey);
   writeln;
   write(ansistring(buf));
   end;
  end;
 end;
end;
begin
clrscr;
writeln('����������');
writeln('��Ȩ���� ��ð�ؾ� (c) 2016 ��ʥ��');
writeln('****************************************');
writeln('����UDPЭ���crt����');
writeln('ע������ʱ�����һЩ����');
writeln('������Է�IP��');
readln(ip);
udpserversocket:=fpsocket(AF_INET,SOCK_DGRAM,0);
server_addr.sin_family:=AF_INET;
server_addr.sin_port:=htons(1000);
server_addr.sin_addr.s_addr:=0;
client_addr.sin_family:=AF_INET;
client_addr.sin_port:=htons(1000);
client_addr.sin_addr:=StrToNetAddr(ip);
fpbind(udpServerSocket, @server_addr,sizeof(server_addr));
if socketerror=0 then
begin;
createthread(nil,0,@recv,@udpserversocket,0,tid);
 while true do
 begin;
 writeln('�ң�');
 i:=-1;
 c:=chr(0);
  while true do
  begin;
  c:=readkey;
   if c=chr(13) then
   begin;
   write(c);
   break;
   end;
   if c=chr(8) then
    if i>-1 then
    begin;
     if i mod (windmaxx-windminx+1)=windmaxx-windminx then
     begin;
     gotoxy(windmaxx-windminx,wherey-1);
     write(' '+c);
     end
     else
     write(c+' '+c);
    buf[i]:=chr(0);
    dec(i);
     if i mod (windmaxx-windminx+1)=windmaxx-windminx then
     gotoxy(wherex,wherey-1);
    end;
   if (c<>chr(8)) and (c<>chr(13)) then
   begin;
   inc(i);
   buf[i]:=c;
   write(c);
   end;
   if (i mod (windmaxx-windminx+1)=windmaxx-windminx) and (i>-1) then
   writeln;
  end;
 writeln;
 fpsendto(udpserversocket,@buf,i+1,0,@client_addr,sizeof(client_addr));
 end;
end;
end.
