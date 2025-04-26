const express = require('express');
const R = require('r-integration');
const app = express();
const port = 3000;

app.use(express.json());

app.post('/run-command', (req, res) => {
    const { command } = req.body;
    if (!command) {
        return res.status(400).json({ error: 'Command is required' });
    }
    try {
        const result = R.executeRCommand(command);
        res.json({ result });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.post('/run-script', (req, res) => {
    const { scriptPath } = req.body;
    if (!scriptPath) {
        return res.status(400).json({ error: 'Script path is required' });
    }
    try {
        const result = R.executeRScript(scriptPath);
        res.json({ result });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

app.listen(port, () => {
    console.log(`Pocket R API running at http://localhost:${port}`);
});
