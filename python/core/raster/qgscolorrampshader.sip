class QgsColorRampShader : QgsRasterShaderFunction
{
%TypeHeaderCode
#include <qgscolorrampshader.h>
%End

  public:
    //! Supported methods for color interpolation.
    enum Type
    {
      Interpolated, //!< Interpolates the color between two class breaks linearly.
      Discrete,     //!< Assigns the color of the higher class for every pixel between two class breaks.
      Exact         //!< Assigns the color of the exact matching value in the color ramp item list
    };

    //! Classification modes used to create the color ramp shader
    enum ClassificationMode
    {
      Continuous = 1, //!< Uses breaks from color palette
      EqualInterval = 2, //!< Uses equal interval
      Quantile = 3 //!< Uses quantile (i.e. equal pixel) count
    };

    /** Creates a new color ramp shader.
     * @param minimumValue minimum value for the raster shader
     * @param maximumValue maximum value for the raster shader
     * @param type interpolation type used
     * @param classificationMode method used to classify the color ramp shader
     * @param colorRamp vector color ramp used to classify the color ramp shader
     * @returns new QgsColorRampShader
     */
    QgsColorRampShader( double minimumValue = 0.0, double maximumValue = 255.0, QgsColorRamp* colorRamp = nullptr, Type type = Interpolated, ClassificationMode classificationMode = Continuous );

    ~QgsColorRampShader();

    //An entry for classification based upon value.
    //Such a classification is typically used for
    //single band layers where a pixel value represents
    //not a color but a quantity, e.g. temperature or elevation
    struct ColorRampItem
    {
      //! default constructor
      ColorRampItem();
      //! convenience constructor
      ColorRampItem( double val, const QColor& col, const QString& lbl = QString() );

      QString label;
      double value;
      QColor color;

      // compare operator for sorting
      bool operator<( const QgsColorRampShader::ColorRampItem& other ) const;
    };

    /** \brief Get the custom colormap*/
    QList<QgsColorRampShader::ColorRampItem> colorRampItemList() const;

    /** \brief Get the color ramp type */
    Type colorRampType() const;

    /** Get the source color ramp
     * @note added in QGIS 3.0
     * @see setSourceColorRamp()
     */
    QgsColorRamp* sourceColorRamp() const /Factory/;

    /** Set the source color ramp
     * @note added in QGIS 3.0
     * @see sourceColorRamp()
     */
    void setSourceColorRamp( QgsColorRamp* colorramp /Transfer/ );

    /** \brief Get the color ramp type as a string */
    QString colorRampTypeAsQString();

    /** \brief Set custom colormap */
    void setColorRampItemList( const QList<QgsColorRampShader::ColorRampItem>& list ); //TODO: sort on set

    /** \brief Set the color ramp type*/
    void setColorRampType( QgsColorRampShader::Type colorRampType );

    /** \brief Set the color ramp type*/
    void setColorRampType( const QString& type );

    /** Classify color ramp shader
     * @param classes number of classes
     * @param band raster band used in classification (only used in quantile mode)
     * @param extent extent used in classification (only used in quantile mode)
     * @param input raster input used in classification (only used in quantile mode)
     */
    void classifyColorRamp( const int classes = 0, const int band = -1, const QgsRectangle& extent = QgsRectangle(), QgsRasterInterface* input = nullptr );

    /** Classify color ramp shader
     * @param band raster band used in classification (only used in quantile mode)
     * @param extent extent used in classification (only used in quantile mode)
     * @param input raster input used in classification (only used in quantile mode)
     */
    void classifyColorRamp( const int band = -1, const QgsRectangle& extent = QgsRectangle(), QgsRasterInterface* input = nullptr ) /PyName=classifyColorRampV2/;


    /** \brief Generates and new RGB value based on one input value */
    bool shade( double, int* /Out/, int* /Out/, int* /Out/, int* /Out/ );

    /** \brief Generates and new RGB value based on original RGB value */
    bool shade( double, double, double, double, int* /Out/, int* /Out/, int* /Out/, int* /Out/);

    void legendSymbologyItems( QList< QPair< QString, QColor > >& symbolItems /Out/ ) const;

    //! Sets classification mode
    void setClassificationMode( ClassificationMode classificationMode );

    //! Returns the classification mode
    ClassificationMode classificationMode() const;

    /** Sets whether the shader should not render values out of range.
     * @param clip set to true to clip values which are out of range.
     * @see clip()
     */
    void setClip( bool clip );

    /** Returns whether the shader will clip values which are out of range.
     * @see setClip()
     */
    bool clip() const;
};
