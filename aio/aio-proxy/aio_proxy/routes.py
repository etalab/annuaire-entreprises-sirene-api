from aiohttp import web
import json

routes = web.RouteTableDef()


@routes.get('/hello')
async def search_endpoint(request):
    res = { 'message': 'hello' }
    return web.Response(text=json.dumps(res))


