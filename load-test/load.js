import http from 'k6/http';

const apiURL = 'http://51.250.2.24/shorten?url=http://google.com'

export const options = {
    vus: 500,
    duration: '1m',
  };


export default function () {



    const params = {
        headers: {  'Content-Type': 'application/json',}
        };
        const res = http.get(apiURL , params);
        console.log(res)

  

      

}