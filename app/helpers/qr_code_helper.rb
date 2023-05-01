# :nocov:

module QrCodeHelper
  def qr_code_as_svg(uri)
    qrcode = RQRCode::QRCode.new(uri)

    qrcode.as_svg(
      color: '000',
      shape_rendering: 'crispEdges',
      module_size: 4,
      use_path: true
    )
  end
end
