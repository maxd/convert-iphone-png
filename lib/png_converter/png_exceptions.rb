class PNGException < Exception
end

class PNGIncorrectSignatureException < PNGException
end

class PNGStandardFormatException < PNGException
end