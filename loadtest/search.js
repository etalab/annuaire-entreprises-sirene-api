import http from 'k6/http';
import { check } from 'k6';
import { Counter } from 'k6/metrics';

// A simple counter for http requests
export const requests = new Counter('http_reqs');

export let options = {
  vus: 10,
  duration: '1m',
  // iterations: 10000
};

export default function () {
  const q = 'la%20poste';
  const res = http.get(`http://recherche.entreprise.dataeng.etalab.studio/search?q=${q}&page=1&per_page=100`);
  const checkRes = check(res, {
    'status is 200': (r) => r.status === 200,
    'response body': (r) => r.body.indexOf('unite_legale') !== -1,
  });
}
