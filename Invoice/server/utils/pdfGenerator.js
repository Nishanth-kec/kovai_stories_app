import PDFDocument from "pdfkit";
import fs from "fs";

export const generateInvoicePDF = (invoice, client, company, outputPath) => {
  return new Promise((resolve, reject) => {
    try {
      const doc = new PDFDocument({ margin: 50 });

      const stream = fs.createWriteStream(outputPath);
      doc.pipe(stream);

      // --- Header ---
      doc
        .fontSize(20)
        .text(company.name, { align: "left" })
        .fontSize(10)
        .text(company.address || "")
        .moveDown();

      doc
        .fontSize(16)
        .text(`INVOICE #${invoice.number}`, { align: "right" })
        .fontSize(10)
        .text(`Issue Date: ${invoice.issueDate}`, { align: "right" })
        .text(`Due Date: ${invoice.dueDate || "-"}`, { align: "right" })
        .moveDown();

      // --- Bill To ---
      doc
        .fontSize(14)
        .text("Bill To:")
        .fontSize(11)
        .text(client.name)
        .text(client.email || "")
        .text(client.phone || "")
        .moveDown();

      // --- Items Table Header ---
      doc.fontSize(12).text("Description", 50);
      doc.text("Qty", 300);
      doc.text("Unit Price", 350);
      doc.text("Total", 450);

      doc.moveDown();

      // --- Items Rows ---
      invoice.items.forEach((item) => {
        doc.fontSize(11).text(item.description, 50);
        doc.text(item.qty, 300);
        doc.text(item.unitPrice.toFixed(2), 350);
        doc.text(item.total.toFixed(2), 450);

        doc.moveDown(0.4);
      });

      doc.moveDown();

      // --- Totals ---
      doc.text(`Subtotal: ${invoice.subTotal.toFixed(2)}`, 400);
      doc.text(`Tax: ${invoice.tax.toFixed(2)}`, 400);
      doc.text(`Discount: ${invoice.discount.toFixed(2)}`, 400);
      doc.fontSize(14).text(`Total: ${invoice.total.toFixed(2)}`, 400);

      doc.end();

      stream.on("finish", () => resolve(outputPath));
      stream.on("error", reject);
    } catch (err) {
      reject(err);
    }
  });
};
