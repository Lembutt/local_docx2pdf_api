host 127.0.0.1
port 8085

json request = {
	"file": "path/to/file",
	"outdir": "path_1/to_1/outdir"
}

responses: 1. 200 - ok;
	   2. 400 - invalid syntax;
           3. 500 - server error;
