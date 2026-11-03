"use strict";

// 營運成本為管理員手動填寫的每月帳務紀錄；不修改玩家餘額、訂單或金流。
function registerAdminOperatingCosts(exports, {onCall, HttpsError, db, FieldValue, requireRewardCampaignAdmin, APP_ID}) {
  const REGION = 'us-central1';
  const KEYS = ['gemini','firebase','runpod','elevenlabs','otherAi','marketing','other','platformFees'];
  const docFor = month => db.collection('artifacts').doc(APP_ID)
    .collection('admin_operating_cost_monthly').doc(month);
  function validateMonth(value) {
    const month = String(value || '');
    if (!/^20\d{2}-(0[1-9]|1[0-2])$/.test(month))
      throw new HttpsError('invalid-argument', '月份必須是 YYYY-MM');
    return month;
  }
  function money(value, label) {
    const amount = Number(value);
    if (!Number.isFinite(amount) || amount < 0 || amount > 100000000)
      throw new HttpsError('invalid-argument', `${label} 必須是非負有效金額`);
    return Math.round(amount * 100) / 100;
  }
  function normalize(amounts) {
    const o = amounts && typeof amounts === 'object' && !Array.isArray(amounts) ? amounts : {};
    for (const key of Object.keys(o)) {
      if (!KEYS.includes(key)) throw new HttpsError('invalid-argument', '不支援的成本類型');
    }
    return Object.fromEntries(KEYS.map(key => [key, money(o[key] ?? 0, key)]));
  }
  function report(month, data = {}) {
    const costs = normalize(data.costs || {});
    const revenueGross = money(data.revenueGross ?? 0, '收入');
    const fees = costs.platformFees;
    const operatingCosts = Math.round(KEYS.filter(k => k !== 'platformFees')
      .reduce((sum, k) => sum + costs[k], 0) * 100) / 100;
    const totalCosts = Math.round((operatingCosts + fees) * 100) / 100;
    return {
      month, currency: 'TWD', revenueGross, costs,
      operatingCosts, platformFees: fees, totalCosts,
      revenueAfterFees: Math.round((revenueGross-fees)*100)/100,
      balance: Math.round((revenueGross-totalCosts)*100)/100,
      notes: String(data.notes || '').slice(0, 1000),
      updatedAt: data.updatedAt?.toDate?.()?.toISOString?.() || null,
    };
  }
  exports.getAdminOperatingCostsUs = onCall({region: REGION, memory: '256MiB', timeoutSeconds: 30}, async request => {
    requireRewardCampaignAdmin(request);
    const month = validateMonth(request.data?.month);
    const snap = await docFor(month).get();
    return {success: true, exists: snap.exists, ...report(month, snap.data() || {})};
  });
  exports.saveAdminOperatingCostsUs = onCall({region: REGION, memory: '256MiB', timeoutSeconds: 30}, async request => {
    const uid = requireRewardCampaignAdmin(request);
    const month = validateMonth(request.data?.month);
    const costs = normalize(request.data?.costs);
    const revenueGross = money(request.data?.revenueGross ?? 0, '收入');
    const notes = String(request.data?.notes || '').trim();
    if (notes.length > 1000) throw new HttpsError('invalid-argument','備註最多 1000 字');
    await docFor(month).set({month, currency:'TWD', costs, revenueGross, notes,
      updatedAt: FieldValue.serverTimestamp(), updatedBy: uid}, {merge: true});
    return {success: true, ...report(month, {costs,revenueGross,notes})};
  });
}
module.exports = {registerAdminOperatingCosts};
