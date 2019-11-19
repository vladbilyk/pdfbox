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
            Console.WriteLine(ParseUsingPdfBox("demo.pdf"));
            Console.WriteLine("Done!");
        }

        private static string ParseUsingPdfBox(string input)
        {
            PDDocument doc = null;

            try
            {
                doc = PDDocument.load(new java.io.File(input));
                var stripper = new PDFTextStripper();
                return stripper.getText(doc);
            }
            finally
            {
                doc?.close();
            }
        }
    }

}
