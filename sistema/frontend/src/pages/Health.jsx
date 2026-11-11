import { useEffect, useState } from 'react';
import api from '../api/api';

export default function Health() {
  const [resposta, setResposta] = useState(null);
  const [erro, setErro] = useState(null);

  useEffect(() => {
    api
      .get('/health')
      .then((res) => setResposta(res.data))
      .catch((err) => setErro(err.message));
  }, []);

  return (
    <div style={{ padding: 24, fontFamily: 'sans-serif' }}>
      <h1>Helpdesk - teste de conexão</h1>
      {!resposta && !erro && <p>Consultando a API...</p>}
      {resposta && (
        <p style={{ color: 'green' }}>
          Front, API e banco conversando: {JSON.stringify(resposta)}
        </p>
      )}
      {erro && <p style={{ color: 'red' }}>Falha ao chamar a API: {erro}</p>}
    </div>
  );
}
