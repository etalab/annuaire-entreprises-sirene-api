import pandas as pd
from elasticsearch import Elasticsearch, helpers
import requests
from requests.auth import HTTPBasicAuth
import json
import secrets
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)

CORS(app)

def ban_words(terms):
    terms = terms.lower()
    terms = terms.split(' ')
    bans=['rue','avenue','de','la','le','du']
    terms = list(set(terms) - set(bans))
    return ' '.join(terms)

def get_result(hit):
    result = {}
    if(hit['_score'] is not None):
        result['_score'] = hit['_score']
    if(hit['_source']['siren'] is not None):
        result['siren'] = hit['_source']['siren']
    if(hit['_source']['nom_complet'] is not None):
        result['nom_complet'] = hit['_source']['nom_complet']
    if(hit['_source']['geo_adresse'] is not None):
        result['geo_adresse'] = hit['_source']['geo_adresse']
    if(hit['_source']['nombre_etablissements'] is not None):
        result['nombre_etablissements'] = str(hit['_source']['nombre_etablissements'])
    if(hit['_source']['identifiantAssociationUniteLegale'] is not None):
        result['identifiantAssociationUniteLegale'] = str(hit['_source']['identifiantAssociationUniteLegale'])
    return result

def display_result(hit):
    result = ''
    if(hit['_score'] is not None):
        result = result + str(hit['_score'])+' - '
    if(hit['_source']['siren'] is not None):
        result = result + hit['_source']['siren']+' - '
    if(hit['_source']['nom_complet'] is not None):
        result = result + hit['_source']['nom_complet']+' - '
    if(hit['_source']['geo_adresse'] is not None):
        result = result + hit['_source']['geo_adresse']+' - '
    if(hit['_source']['nombre_etablissements'] is not None):
        result = result + str(hit['_source']['nombre_etablissements'])
    
    return result

def is_adress(terms):
    l1 = terms.split(' ')
    l1 = [x.lower() for x in l1]
    l2 = ['rue', 'avenue', 'route', 'boulevard', 'r', 'av', 'bvd', 'bv', 'av', 'voie', 'chemin', 'place', 'pl']
    check = any(item in l2 for item in l1)
    if check:
        headers = {
            "Content-Type": "application/json"
        }
        body = {
            "q": terms
        }
        r = requests.get('https://api-adresse.data.gouv.fr/search/?q='+terms, headers=headers)

        if(r.status_code == 200):
            if(len(r.json()['features']) > 0):
                if(r.json()['features'][0]['properties']['score'] > 0.8):
                    return True
                else:
                    return False
            else:
                return False
        else:
            return False
    else:
        return False
    

def search_es_by_adress(terms):    
    terms = ban_words(terms)
    headers = {
        "Content-Type": "application/json"
    }
    body = {
        "sort" : [
            { "etat_administratif_etablissement.keyword" : "asc" },
            "_score"
        ],
        "query": {
            "multi_match": {
            "query": terms,
            "type": "most_fields",
            "fields": [
                "geo_adresse^10"
                ]
            }
        }
    }
    r = requests.get(secrets.ELK_URL+'/siren/_search', auth=HTTPBasicAuth(secrets.ELK_USER,secrets.ELK_PASSWORD), headers=headers, data=json.dumps(body))
    arr = []
    for hit in r.json()['hits']['hits']:
        result = get_result(hit)
        arr.append(result)
    return arr


def search_es_partial_id(terms, index, prop):
    headers = {
        "Content-Type": "application/json"
    }
    body = {
        "sort" : [
            { "etat_administratif_etablissement.keyword" : "asc" },
            { "nombre_etablissements" : "desc" }
        ],
        "query": {
            "prefix": {
              prop+".keyword": {
                "value": terms
              }
            }
          }
    }
    r = requests.get(secrets.ELK_URL+'/'+index+'/_search', auth=HTTPBasicAuth(secrets.ELK_USER,secrets.ELK_PASSWORD), headers=headers, data=json.dumps(body))
    arr = []
    for hit in r.json()['hits']['hits']:
        result = get_result(hit)
        arr.append(result)
    return arr

def search_es_exact_id(terms, index, prop):
    headers = {
        "Content-Type": "application/json"
    }
    body = {
        "sort" : [
            { "etat_administratif_etablissement.keyword" : "asc" },
            { "nombre_etablissements" : "desc" }
        ],
        "query": {
          "term": {
            prop+".keyword": {
              "value": terms,
              "boost": 1.0
            }
          }
        }
    }
    r = requests.get(secrets.ELK_URL+'/'+index+'/_search', auth=HTTPBasicAuth(secrets.ELK_USER,secrets.ELK_PASSWORD), headers=headers, data=json.dumps(body))
    arr = []
    for hit in r.json()['hits']['hits']:
        result = get_result(hit)
        arr.append(result)
    return arr

def is_id(terms):
    for t in terms.split(' '):
        try:
            int(t)
            if((len(t) < 9) & (len(t) > 6)):
                # recherche partielle
                result = search_es_partial_id(t, 'siren', 'siren')
                if(result != []):
                    return result
            else:
                if(len(t) == 9):
                    # recherche exact 
                    result = search_es_exact_id(t, 'siren', 'siren')
                    if(result != []):
                        return result
                else:
                    if((len(t) < 14) & (len(t) > 6)):
                        # recherche partiel siret
                        result = search_es_partial_id(t, 'siret', 'siret')
                        if(result != []):
                            return result
                    elif(len(t) == 14):
                        # recherche exact siret
                        result = search_es_exact_id(t, 'siret', 'siret')
                        if(result != []):
                            return result
        except:
            if(len(t) > 0):
                if(t[0] == 'W'):
                    try:
                        int(t[1:])
                        if(len(t) == 10):
                            result = search_es_exact_id(t, 'siren', 'identifiantAssociationUniteLegale')
                            if(result != []):
                                return result
                        elif(len(t) < 9):
                            result = search_es_partial_id(t, 'siren', 'identifiantAssociationUniteLegale')
                            if(result != []):
                                return result
                    except:
                        pass
            pass
    return []

def search_es_by_name(terms):
    terms = ban_words(terms)
    headers = {
        "Content-Type": "application/json"
    }
    body = {
        "sort" : [
            { "etat_administratif_etablissement.keyword" : "asc" },
            "_score"
        ],
        "query":{
            "bool":{
                "should":[{
                    "function_score": {
                        "query": {
                            "bool":{  
                              "should":[  
                                {  
                                  "multi_match":{  
                                    "query":terms,
                                    "type":"phrase",
                                    "fields":[  
                                        "nom_complet^15",
                                        "siren^3",
                                        "siret^3",
                                        "identifiantAssociationUniteLegale^3"
                                    ],
                                    "boost":5
                                  }
                                }
                              ]
                            }
                          },
                        "functions": [{
                            "field_value_factor": {
                                "field": "nombre_etablissements",
                                "factor": 5,
                                "modifier": "sqrt",
                                "missing": 1
                                }
                            }
                        ]
                    }
                },
                {  
                  "multi_match":{  
                    "query":terms,
                    "type":"most_fields",
                    "fields":[  
                        "nom_complet^10",
                    ],
                    "fuzziness" : "AUTO"

                  }
                }
                ]
            }
        }
    }
        
    r = requests.get(secrets.ELK_URL+'/siren/_search',
                     auth=HTTPBasicAuth(secrets.ELK_USER,secrets.ELK_PASSWORD),
                     headers=headers, 
                     data=json.dumps(body))
    arr = []
    for hit in r.json()['hits']['hits']:
        result = get_result(hit)
        arr.append(result)
    return arr

def search_es(terms):
    isid = is_id(terms)
    if(len(isid) == 0):
        isadress = is_adress(terms)
        if(isadress):
            result = search_es_by_adress(terms)
        else:
            result = search_es_by_name(terms)
        return result
    else:
        return isid


@app.route('/search')
def hello():
    terms = request.args.get('q')
    return jsonify(search_es(terms))
    

if __name__ == '__main__':
      app.run(host='0.0.0.0', port=5057)