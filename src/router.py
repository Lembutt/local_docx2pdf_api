from aiohttp import web
import os
from datetime import datetime
from logger import logger


class ConvertRequest:
    def __init__(self, req, values: dict):
        self.__dict__ = values
        self.request = req
    
    async def process(self):
        start_time = datetime.now()
        try:
            query = f'libreoffice --headless --convert-to pdf:writer_pdf_Export {data.file} --outdir {data.outdir}'
        except Exception as e:
            logger.error(f'Client error: {e}')
            return web.Response(
                text=f'Invalid syntax: {e}',
                status=400
            )
    
        try:
            os.system(query)
        except Exception as e:
            logger.error(f'Server error: {e}')
            return web.Response(
                text=f'Server cannot manage request: {e}',
                status=500
            )
        end_time = datetime.now() - start_time
        json_debug = f""" "request": {await self.request.text()}, "query": "{query}", "completed_in": "{end_time}" """
        logger.debug("{" + json_debug + "}")
        return web.Response(
            text=f'OK',
            status=200
        )

routes = web.RouteTableDef()

@routes.get('/convert')
async def convert(req):
    data = ConvertRequest(req, await req.json())
    return await data.process()

@routes.get('/avgtime')
async def avg_time(req):
    ...
