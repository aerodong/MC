
local component = require("component")
local io = require("io")
if not component.isAvailable("tunnel") then error("A linked card is required for this program. Please install.") end
local tunnel = component.tunnel
print("Gangsir's Simple File Transfer init... Current max packet size is "..tunnel.maxPacketSize())


local args = {...} --{send/receive,filename}
if args[1] == nil then error("Provide function of program in first arg, send or receive.") end


if args[1] == "send" then
  if args[2] == nil then error("Provide filesystem path to file to send.") end
  print("Preparing to send file "..args[2])
  local fileSendInitial = assert(io.open(args[2],"r"),"Failed to open existing file to send.")
  local sendString = fileSendInitial:read("*a") --reads the entire file into one gigantic string
  print("File sent. Ensure that another computer is running gft receive. Resend if necessary.")
  fileSendInitial:close()
end

if args[1] == "receive" then
  if args[2] == nil then error("Provide filesystem path to file to create on receive.") end
  print("Preparing to receive file over network into "..args[2])
  local _,_,sender,_,_,receivedFileData = require("event").pull("modem")
  print("Got data from computer "..sender..".")
  local fileReceiveFinal = assert(io.open(args[2],"w"),"Failed to open new file to receive into.")
  fileReceiveFinal:write(receivedFileData)
  fileReceiveFinal:flush()
  fileReceiveFinal:close()
  print("Done.")
end
print("Thank you for using gft.")

--eof
