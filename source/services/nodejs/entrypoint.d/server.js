import { createServer } from 'http';

const PORT = process.env.PORT || 3000;

const server = createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('Simple Node.js Service Running\n');
});

server.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
