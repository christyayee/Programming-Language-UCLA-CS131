import asyncio
import aiohttp
import json
import time
import sys

Clients = {}
Server = sys.argv[1]
Server_port = {'Goloman':19455, 'Hands':19456, 'Holiday':19457, 'Welsh':19458, 'Wilkes':19459}
Server_relation = {'Goloman':['Hands','Holiday','Wilkes'],'Hands':['Wilkes'],'Holiday':['Welsh','Wilkes']}
Host = 'localhost'
Key = 'AIzaSyDlrl2AypJA4EhtEYmyi6ZXvx8nOM78c70'
Google_place_api = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json'

class EchoServerClientProtocol(asyncio.Protocol):

	def __init__(self, loop):
		self.loop = loop

	def connection_made(self, transport):
		self.transport = transport

	def cal_time(server_time, user_time):
		diff_time = server_time - user_time
		if diff_time > 0:
			return '+' + str(diff_time)
		else:
			return '-' + str(diff_time)

	def is_number(self, str):
		if str.isdigit():
			return True
		str_list = str.split('.')
		if str_list.length() != 2:
			return False
		if str_list[0].isdigit() and str_list[1].isdigit():
			return True
		return False
	#FLOOD==========================================
	def flood(self, message, port):
		for server in Server_relation[Server]:
			if port != Server_port[server]:
				reader, writer = await asyncio.open_connection(host=Host, port=Server_port[server], loop=self.loop)
				writer.write(message.encode())
				await writer.drain()
				writer.close()
		self.transport.close()
	#===============================================
	
	#IAMAT===========================================
	def check_IAMAT(self,args):
		if args.length() != 4:
			return False
		if (args[2].count('+') + args[2].count('-')) != 2:
			return False
		if args[2][0] != '+' and args[2][0] != '-':
			return False
		coordinate = args[2].replace('+',' ').replace('-',' ').split()
		if coordinate.length() != 2:
			return False
		if not (is_number(coordinate[0]) and is_number(coordinate[1])):
			return False
		if not is_number(args[3]):
			return False
		return True

	def handle_IAMAT(self, args, time, port):
		time_diff = cal_time(time, float(args[3]))
		message = "AT {0} {1} {2} {3} {4}".format(Server, time_diff, args[1], args[2], args[3])
		Clients[args[1]] = {'AT':message, 'location':args[2]}
		flood(message, port)
		self.transport.write(message.encode())
		self.transport.close()
	#IAMAT===========================================

	#WHATSAT=========================================
	def formate_location(self, location):
		res = []
		for c in location:
			if c == '+':
				res.append(c)
			if c == '-':
				res.append(c)
		coordinate = location.replace('+',' ').replace('-',' ').split()
		return c[0]+coordinate[0]+c[1]+coordinate[1]

	def check_WHATSAT(self, args):
		if not (args.length() == 4 and args[2].isdigit() and args[3].isdigit()):
			return False
		if float(args[2])>=50 or float(args[2])<=0 or float(args[3])>=20 or float(args[3])<=0:
			return False
		if args[1] in Clients:
			return False
		return True

	async def fetch(session, url):
		async with async_timeout.timeout(10):
			async with session.get(url) as response:
				return await response.text()

	def handle_WHATSAT(self, args):
		url = Google_place_api + '?location={0}&radius={1}&key={3}'.format(formate_location(Clients[args[1]]['location']), str(float(args[2])*1000), Key)
		async with aiohttp.ClientSession() as session:
			response = await fetch(session, url)
			json_res = json.loads(response)
			json_res['results'] = json_res['results'][:int(args[3])]
			final_res = json.dumps(json_res)
			self.transport.write(Clients[args[1]]['AT'].encode())
			self.transport.close()
	#WHATSAT=========================================

	#AT==============================================
	def check_sender(self, port):
		for server in Server_port:
			if port == Server_port[server]:
				return True
		return False

	def check_circle(self, args, message):
		if not (args[3] in Clients):
			return True
		elif Clients[args[3]]['AT'] != message:
			return True
		return False

	def handle_AT(self, args, message, port):
		Clients[args[3]]['AT']=message
		Clients[args[3]]['location']=args[4]
		flood(message, port)
	#================================================

	#SERVER==========================================
	def data_received(self, data):
		_, port = self.transport.get_extra_info('peername')
		recieve_time = time.time()
		data = data.decode()
		args = data.split()
		if args[0] == 'IAMAT':
			if check_IAMAT(args):
				handle_IAMAT(args, recieve_time, port)
			else:
				self.transport.write("? {}".format(data).encode())
				self.transport.close()
		elif args[0] == 'WHATSAT':
			if check_WHATSAT(args):
				handle_WHATSAT(args)
			else:
				self.transport.write("? {}".format(data).encode())
				self.transport.close()
		elif args[0] == 'AT':
			if not check_sender(port):
				self.transport.write("? {}".format(data).encode())
				self.transport.close()
			elif check_circle(args, data): 
				handle_AT(args, data, port)
			self.transport.close()
		else:
			self.transport.write("? {}".format(data).encode())
			self.transport.close()
	#================================================


def main():
	
	loop = asyncio.get_event_loop()
	coro = loop.create_server(lambda:EchoServerClientProtocol(loop), Host, Server_port[Server])
	server = loop.run_until_complete(coro)

	try:
		loop.run_forever()
	except KeyboardInterrupt:
		pass

	server.close()

if __name__ == "__main__":
	main()