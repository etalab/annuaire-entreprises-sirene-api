from aiohttp import web


ESCAPED_CHARS = "!@#$\'\"()/&`\\§°*£%+=-_;.,?:"

routes = web.RouteTableDef()


def sanatize_param(param):
    param = param.translate({ord(c): None for c in ESCAPED_CHARS})
    param = ' & '.join(param.split())
    return param.lower()


@routes.get('/search')
async def search_endpoint(request):
    output_url = request.app['config']['output_url_search']

    json_body = {
        'search': sanatize_param(request.rel_url.query['q']),
        'page_ask': request.rel_url.query['page'],
        'per_page_ask': request.rel_url.query['per_page']
    }

    async with request.app['http_session'].post(output_url, json=json_body) as resp:
        res_status = resp.status
        res = await resp.json()

    return web.json_response(res, status=res_status)


@routes.get('/siren')
async def search_endpoint(request):
    output_url = request.app['config']['output_url_siren']

    json_body = {
        'siren_search': request.rel_url.query['q']
    }

    async with request.app['http_session'].post(output_url, json=json_body) as resp:
        res_status = resp.status
        res = await resp.json()

    return web.json_response(res, status=res_status)
