"""Production-ready OCR service supporting text, image, and PDF medical reports using pytesseract, pdf2image, and Pillow."""

import io
import logging
from typing import Dict, Union
from PIL import Image

try:
    import pytesseract
except ImportError:
    pytesseract = None

try:
    import pdf2image
except ImportError:
    pdf2image = None

logger = logging.getLogger(__name__)


def extract_text_from_report(report_text: str) -> str:
    """Clean and normalize plain text medical reports."""
    if not report_text:
        return ''
    return ' '.join(report_text.split())


def extract_text_from_image_bytes(image_bytes: bytes) -> str:
    """Extract text from an image (PNG, JPEG, TIFF) using Pillow and pytesseract."""
    if not image_bytes:
        return ''
    try:
        image = Image.open(io.BytesIO(image_bytes))
        if pytesseract is not None:
            text = pytesseract.image_to_string(image)
            return extract_text_from_report(text)
        else:
            return '[OCR Warning: pytesseract is not installed]'
    except Exception as e:
        logger.warning(f'Image OCR extraction encountered error: {e}')
        return f'[OCR Error: Failed to process image - {str(e)}]'


def extract_text_from_pdf_bytes(pdf_bytes: bytes) -> str:
    """Convert PDF pages to images using pdf2image and extract text with pytesseract."""
    if not pdf_bytes:
        return ''
    try:
        if pdf2image is not None and pytesseract is not None:
            images = pdf2image.convert_from_bytes(pdf_bytes)
            page_texts = []
            for i, img in enumerate(images):
                page_text = pytesseract.image_to_string(img)
                if page_text.strip():
                    page_texts.append(f'--- Page {i+1} ---\n' + page_text.strip())
            extracted = '\n\n'.join(page_texts)
            return extract_text_from_report(extracted) if extracted else '[OCR Note: No readable text found in PDF]'
        else:
            return '[OCR Warning: pdf2image or pytesseract is not available]'
    except Exception as e:
        logger.warning(f'PDF OCR extraction encountered error: {e}')
        return f'[OCR Error: Failed to process PDF - {str(e)}]'


def extract_text_from_file(file_bytes: bytes, filename: str) -> Dict[str, str]:
    """Auto-detect file format (PDF vs Image) and return extracted text with metadata."""
    if not filename:
        filename = 'report.txt'
    
    ext = filename.lower().split('.')[-1]
    
    if ext == 'pdf':
        text = extract_text_from_pdf_bytes(file_bytes)
        source_type = 'pdf'
    elif ext in ['png', 'jpg', 'jpeg', 'tif', 'tiff', 'bmp']:
        text = extract_text_from_image_bytes(file_bytes)
        source_type = 'image'
    else:
        # Fallback assuming UTF-8 plain text file
        try:
            raw_text = file_bytes.decode('utf-8', errors='ignore')
            text = extract_text_from_report(raw_text)
            source_type = 'text'
        except Exception:
            text = '[OCR Error: Unsupported file format]'
            source_type = 'unknown'

    return {
        'filename': filename,
        'source_type': source_type,
        'extracted_text': text
    }
