export const generateInvoiceNumber = (companyId) => {
  const random = Math.floor(Math.random() * 90000) + 10000;
  return `INV-${companyId.toString().slice(-4)}-${random}`;
};
