from aiohttp import web


ESCAPED_CHARS = "!@#$\'\"()/&`\\§°*£%+=_;.,?:<>"


TYPEVOIES = ['promenade','avenue','boulevard','place', 'carrefour', 'passage', 'allee', 'impasse', 'lieu dit', 'hameau', 'rue']

routes = web.RouteTableDef()


def sanatize_param(param):
    param = param.translate({ord(c): None for c in ESCAPED_CHARS})
    #param = ' & '.join(param.split())
    return param.lower()

def remove_typvoies(param):
    qw = param.split()
    res = [word for word in qw if word.lower() not in TYPEVOIES]
    return ' & '.join(res)

@routes.get('/search')
async def search_endpoint(request):
    output_url = request.app['config']['output_url_search']

    searchRes = sanatize_param(request.rel_url.query['q'].replace("-"," "))
    searchRes = remove_typvoies(searchRes)

    json_body = {
        'search': searchRes,
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
    try:
        page_ask = request.rel_url.query['page']
    except:
        page_ask = 1

    json_body = {
        'siren_search': request.rel_url.query['q'],
        'page_ask': page_ask
    }

    async with request.app['http_session'].post(output_url, json=json_body) as resp:
        res_status = resp.status
        res = await resp.json()

    return web.json_response(res, status=res_status)



@routes.get('/siret')
async def search_endpoint(request):
    output_url = request.app['config']['output_url_siret']

    json_body = {
        'siret_search': request.rel_url.query['q']
    }

    async with request.app['http_session'].post(output_url, json=json_body) as resp:
        res_status = resp.status
        res = await resp.json()

    return web.json_response(res, status=res_status)
