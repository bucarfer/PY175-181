import socket
import random

server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server_socket.bind(('localhost', 3003))
server_socket.listen()

print("Server is running on localhost:3003")

while True:
    client_socket, addr = server_socket.accept()
    print(f"Connection from {addr}")

    request = client_socket.recv(1024).decode()
    if (not request) or ('favicon.ico' in request):
        client_socket.close()
        continue

    request_line = request.splitlines()[0]

    method, path_and_parameters, _ = request_line.split()
    path, params = path_and_parameters.split("?")

    parameters = {}

    for param in params.split("&"):
        key, value = param.split("=")
        parameters[key] = value

    rolls = int(parameters['rolls'])
    sides = int(parameters['sides'])
    results = []

    for _ in range(rolls):
        results.append(random.randint(1, sides))

    response_body = ('Request Line: {request_line}\n'
                    f'HTTP Method: {method}\n'
                    f'Path: {path}\n'
                    f'Parameters: {parameters}\n')

    for result in results:
          response_body += f"Roll: {result}\n"

    response = ("HTTP/1.1 200 OK\r\n"
                "Content-Type: text/plain\r\n"
                f"Content-Length: {len(response_body)}\r\n"
                "\r\n"
                f"{response_body}\n")

    client_socket.sendall(response.encode())
    client_socket.close()