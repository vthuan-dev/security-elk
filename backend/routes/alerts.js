const express = require('express');
const router = express.Router();
const { protect } = require('../middleware/auth');
const Incident = require('../models/Incident');

/**
 * @swagger
 * /api/alerts:
 *   get:
 *     tags: [Alerts]
 *     summary: Lấy danh sách alerts
 *     description: Trả về danh sách security alerts (tính năng chưa implement đầy đủ)
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: Danh sách alerts (hiện tại trống)
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 success:
 *                   type: boolean
 *                   example: true
 *                 data:
 *                   type: array
 *                   items:
 *                     type: object
 *                   example: []
 *       401:
 *         description: Token không hợp lệ
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/ErrorResponse'
 */
// GET /api/alerts
router.get('/', protect, async (req, res) => {
  try {
    const limit = Math.min(parseInt(req.query.limit) || 20, 100);
    const severities = (req.query.severity || 'high,critical')
      .split(',')
      .map(s => s.trim())
      .filter(Boolean);
    const since = req.query.since ? new Date(req.query.since) : new Date(Date.now() - 24 * 60 * 60 * 1000);

    const query = {
      severity: { $in: severities },
      createdAt: { $gte: since }
    };

    const incidents = await Incident.find(query)
      .sort({ createdAt: -1 })
      .limit(limit)
      .select('title severity status category createdAt source')
      .lean();

    const data = incidents.map((i) => ({
      id: i._id,
      type: 'incident',
      title: i.title,
      severity: i.severity,
      status: i.status,
      category: i.category,
      source: i.source,
      createdAt: i.createdAt
    }));

    res.json({ success: true, data });
  } catch (error) {
    res.status(500).json({ success: false, message: 'Không thể tải alerts', error: error.message });
  }
});

module.exports = router;
