using org.apache.pdfbox.pdmodel;
using org.apache.pdfbox.text;
using System;

namespace PdfToTextDemo
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Launching PDFBox API from .NET");
            Console.WriteLine("Extracting text...");
            Console.WriteLine(ParseUsingPDFBox("demo.pdf"));
            Console.WriteLine("Done!");
        }

        private static string ParseUsingPDFBox(string input)
        {
            PDDocument doc = null;

            try
            {
                doc = PDDocument.load(new java.io.File(input));
                var stripper = new PDFTextStripper();
                var page = doc.getDocumentCatalog().getPages().get(1);

                return stripper.getText(doc);
            }
            finally
            {
                if (doc != null)
                {
                    doc.close();
                }
            }
        }
    }

}
