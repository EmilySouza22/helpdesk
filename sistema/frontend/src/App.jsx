import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Health from './pages/Health';

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        {/* TODO: /login, /principal, /chamados, /atendimento */}
        <Route path="/" element={<Health />} />
      </Routes>
    </BrowserRouter>
  );
}
