from aiohttp import web
import config
import router

if __name__ == '__main__':
    app = web.Application()
    app.add_routes(router.routes)
    web.run_app(
        app,
        host=config.host,
        port=config.port
    )
