from aiohttp import web
import os
import logging

routes = web.RouteTableDef()

@routes.get('/colors')
async def search_endpoint(request):
    return web.json_response({'CURRENT_COLOR': os.getenv('CURRENT_COLOR'), 'NEXT_COLOR': os.getenv('NEXT_COLOR')}, status=200)

