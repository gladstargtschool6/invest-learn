// Portfolio simulator logic
const createPortfolio = (investments) => {
  return investments.reduce((total, investment) => total + investment.amount, 0);
};

module.exports = createPortfolio;
