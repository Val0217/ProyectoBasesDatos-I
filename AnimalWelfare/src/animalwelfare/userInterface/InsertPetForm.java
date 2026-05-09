/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/GUIForms/JFrame.java to edit this template
 */
package animalwelfare.userInterface;
import animalwelfare.access.DbObject;
import animalwelfare.business.InsertPetController;
import java.awt.Color;
import java.awt.Dimension;
import java.util.ArrayList;
import javax.swing.DefaultListModel;
/**
 *
 * @author valer
 */
public class InsertPetForm extends javax.swing.JFrame {
    
    private static final java.util.logging.Logger logger = java.util.logging.Logger.getLogger(InsertPetForm.class.getName());


    // controlador del formulario
    private InsertPetController controller = null;

    // procedimiento que rellena la lista de Veterinarian
    public void fillVeterinarian(ArrayList<DbObject> listVeterinarian) {
        ListVeterinarian.removeAll();
        DefaultListModel<DbObject> model = new DefaultListModel<>();
        for (DbObject c : listVeterinarian) {
            model.addElement(c);
        }
        ListVeterinarian.setModel(model);
    }

    // procedimiento que rellena el combobox de Medicine
    public void fillMedicine(ArrayList<DbObject> listMedicine) {
        ComboMedicine.removeAllItems();
        ComboMedicine.addItem(new DbObject(0,"-"));
        for (DbObject c : listMedicine) {
            ComboMedicine.addItem(c);
        }
    }

    // procedimiento que rellena el combobox de Illness
    public void fillIllness(ArrayList<DbObject> listIllness) {
        ComboIllness.removeAllItems();
        ComboIllness.addItem(new DbObject(0,"-"));
        for (DbObject c : listIllness) {
            ComboIllness.addItem(c);
        }
    }

    // procedimiento que rellena el combobox de Treatment
    public void fillTreatment(ArrayList<DbObject> listTreatment) {
        ComboTreatment.removeAllItems();
        ComboTreatment.addItem(new DbObject(0,"-"));
        for (DbObject c : listTreatment) {
            ComboTreatment.addItem(c);
        }
    }

    // procedimiento que rellena el combobox de Breed
    public void fillPetBreed(ArrayList<DbObject> listBreed) {
        ComboBreed.removeAllItems();
        ComboBreed.addItem(new DbObject(0,"-"));
        for (DbObject c : listBreed) {
            ComboBreed.addItem(c);
        }
    }

    // procedimiento que rellena el combobox de Size
    public void fillPetSize(ArrayList<DbObject> listSize) {
        ComboSize.removeAllItems();
        ComboSize.addItem(new DbObject(0,"-"));
        for (DbObject c : listSize) {
            ComboSize.addItem(c);
        }
    }

    // procedimiento que rellena el combobox de Energy
    public void fillPetEnergy(ArrayList<DbObject> listEnergy) {
        ComboEnergy.removeAllItems();
        ComboEnergy.addItem(new DbObject(0,"-"));
        for (DbObject c : listEnergy) {
            ComboEnergy.addItem(c);
        }
    }

    // procedimiento que rellena el combobox de Space Requiered
    public void fillPetSpaceRequired(ArrayList<DbObject> listSpaceRequiered) {
        ComboSpaceRequired.removeAllItems();
        ComboSpaceRequired.addItem(new DbObject(0,"-"));
        for (DbObject c : listSpaceRequiered) {
            ComboSpaceRequired.addItem(c);
        }
    }

    // procedimiento que rellena el combobox de Pet trainig
    public void fillPetTraining(ArrayList<DbObject> listPetTraining) {
        ComboTraining.removeAllItems();
        ComboTraining.addItem(new DbObject(0,"-"));
        for (DbObject c : listPetTraining) {
            ComboTraining.addItem(c);
        }
    }

    // procedimiento que rellena el combobox de Pet Type
    public void fillPetType(ArrayList<DbObject> listPetType) {
        ComboType.removeAllItems();
        ComboType.addItem(new DbObject(0,"-"));
        for (DbObject c : listPetType) {
            ComboType.addItem(c);
        }
    }

    

    // procedimiento que rellena el combobox de Country
    public void fillCountry(ArrayList<DbObject> listCountry) {
        ComboCountry.removeAllItems();
        ComboCountry.addItem(new DbObject(0,"-"));
        for (DbObject c : listCountry) {
            ComboCountry.addItem(c);
        }
    }
    
    // procedimiento que rellena el combobox de Province
    public void fillProvince(ArrayList<DbObject> listProvince) {
        ComboProvince.removeAllItems();
        ComboProvince.addItem(new DbObject(0,"-"));
        for (DbObject c : listProvince) {
            ComboProvince.addItem(c);
        }
    }
    
    // procedimiento que rellena el combobox de Canton
    public void fillCanton(ArrayList<DbObject> listCanton) {
        ComboCanton.removeAllItems();
        ComboCanton.addItem(new DbObject(0,"-"));
        for (DbObject c : listCanton) {
            ComboCanton.addItem(c);
        }
    }
    
    // procedimiento que rellena el combobox de District
    public void fillDistrict(ArrayList<DbObject> listDistrict) {
        ComboDistrict.removeAllItems();
        ComboDistrict.addItem(new DbObject(0,"-"));
        for (DbObject c : listDistrict) {
            ComboDistrict.addItem(c);
        }
    }

    public InsertPetForm() {
        initComponents(); // Inicializar los componentes del formulario
        controller = new InsertPetController(this);
        setLocationRelativeTo(null); // Centrar el formulario en la pantalla

        ComboProvince.setEnabled(false);
        ComboCanton.setEnabled(false);
        ComboDistrict.setEnabled(false);
        ComboBreed.setEnabled(false);
        
        // fix elementos visuales
        ScrollPanelFirst.getVerticalScrollBar().setBackground(new Color(240,240,240));

        setVisible(true); // Hacer visible el formulario
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        PanelBackGround = new javax.swing.JPanel();
        LableTitle = new javax.swing.JLabel();
        ScrollPanelFirst = new javax.swing.JScrollPane();
        FormPanelInsertPet = new javax.swing.JPanel();
        BasicInformationPanel3 = new javax.swing.JPanel();
        jLabel29 = new javax.swing.JLabel();
        TextName3 = new javax.swing.JTextField();
        TextColor3 = new javax.swing.JTextField();
        jLabel30 = new javax.swing.JLabel();
        jLabel31 = new javax.swing.JLabel();
        SpinnerAge3 = new javax.swing.JSpinner();
        TextChip3 = new javax.swing.JTextField();
        jLabel32 = new javax.swing.JLabel();
        jLabel33 = new javax.swing.JLabel();
        jScrollPane7 = new javax.swing.JScrollPane();
        TextDescription3 = new javax.swing.JTextArea();
        ImagePreview3 = new javax.swing.JLabel();
        ButtonSelectImage3 = new javax.swing.JPanel();
        LabelButtonSelectImage3 = new javax.swing.JLabel();
        jScrollPane2 = new javax.swing.JScrollPane();
        ListImages = new javax.swing.JList<>();
        PetDetailsPanel = new javax.swing.JPanel();
        jLabel6 = new javax.swing.JLabel();
        ComboType = new javax.swing.JComboBox<>();
        ComboSpaceRequired = new javax.swing.JComboBox<>();
        jLabel7 = new javax.swing.JLabel();
        ComboBreed = new javax.swing.JComboBox<>();
        jLabel8 = new javax.swing.JLabel();
        ComboEnergy = new javax.swing.JComboBox<>();
        jLabel9 = new javax.swing.JLabel();
        ComboTraining = new javax.swing.JComboBox<>();
        jLabel10 = new javax.swing.JLabel();
        ComboSize = new javax.swing.JComboBox<>();
        jLabel11 = new javax.swing.JLabel();
        LocationPanel = new javax.swing.JPanel();
        jLabel12 = new javax.swing.JLabel();
        ComboCountry = new javax.swing.JComboBox<>();
        ComboCanton = new javax.swing.JComboBox<>();
        jLabel13 = new javax.swing.JLabel();
        ComboProvince = new javax.swing.JComboBox<>();
        jLabel14 = new javax.swing.JLabel();
        ComboDistrict = new javax.swing.JComboBox<>();
        LabelDistrict = new javax.swing.JLabel();
        VeterinarianPanel = new javax.swing.JPanel();
        jLabel15 = new javax.swing.JLabel();
        TextVeterinarian = new javax.swing.JTextField();
        jScrollPane3 = new javax.swing.JScrollPane();
        ListVeterinarian = new javax.swing.JList<>();
        PetHealthPanel = new javax.swing.JPanel();
        jLabel16 = new javax.swing.JLabel();
        ComboIllness = new javax.swing.JComboBox<>();
        jScrollPane4 = new javax.swing.JScrollPane();
        ListPetMedicine = new javax.swing.JList<>();
        ButtonAddIllness = new javax.swing.JPanel();
        LabelButtonAddIllness = new javax.swing.JLabel();
        jLabel17 = new javax.swing.JLabel();
        ComboMedicine = new javax.swing.JComboBox<>();
        ButtonAddMedicine = new javax.swing.JPanel();
        LabelButtonAddMedicine = new javax.swing.JLabel();
        jScrollPane5 = new javax.swing.JScrollPane();
        ListPetIllness = new javax.swing.JList<>();
        jLabel18 = new javax.swing.JLabel();
        ComboTreatment = new javax.swing.JComboBox<>();
        ButtonAddTreatment = new javax.swing.JPanel();
        LabelButtonAddTreatment = new javax.swing.JLabel();
        jScrollPane6 = new javax.swing.JScrollPane();
        ListPetTreatment = new javax.swing.JList<>();
        FinalPanel = new javax.swing.JPanel();
        ButtonSubmitPet = new javax.swing.JPanel();
        jLabel34 = new javax.swing.JLabel();
        ButtonCancel = new javax.swing.JPanel();
        jLabel35 = new javax.swing.JLabel();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setPreferredSize(new java.awt.Dimension(924, 590));
        setResizable(false);

        PanelBackGround.setBackground(new java.awt.Color(0, 153, 153));
        PanelBackGround.setPreferredSize(new java.awt.Dimension(913, 590));
        PanelBackGround.setLayout(new org.netbeans.lib.awtextra.AbsoluteLayout());

        LableTitle.setFont(new java.awt.Font("Segoe UI", 1, 24)); // NOI18N
        LableTitle.setForeground(new java.awt.Color(255, 255, 255));
        LableTitle.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        LableTitle.setText("Animal Welfare");
        PanelBackGround.add(LableTitle, new org.netbeans.lib.awtextra.AbsoluteConstraints(0, 10, 910, -1));

        ScrollPanelFirst.setPreferredSize(new java.awt.Dimension(911, 510));

        BasicInformationPanel3.setBorder(javax.swing.BorderFactory.createTitledBorder(null, "Basic Information", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Segoe UI", 1, 14), new java.awt.Color(142, 142, 142))); // NOI18N

        jLabel29.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jLabel29.setText("Name:");

        TextName3.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        TextName3.addActionListener(this::TextNameActionPerformed);

        TextColor3.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        TextColor3.addActionListener(this::TextColorActionPerformed);

        jLabel30.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jLabel30.setText("Color:");

        jLabel31.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jLabel31.setText("Age:");

        SpinnerAge3.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N

        TextChip3.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        TextChip3.addActionListener(this::TextChipActionPerformed);

        jLabel32.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jLabel32.setText("Chip:");

        jLabel33.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jLabel33.setText("Description:");

        TextDescription3.setColumns(20);
        TextDescription3.setRows(5);
        jScrollPane7.setViewportView(TextDescription3);

        ImagePreview3.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        ImagePreview3.setForeground(new java.awt.Color(142, 142, 142));
        ImagePreview3.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        ImagePreview3.setText("Image");
        ImagePreview3.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        ButtonSelectImage3.setBackground(new java.awt.Color(0, 102, 102));

        LabelButtonSelectImage3.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        LabelButtonSelectImage3.setForeground(new java.awt.Color(255, 255, 255));
        LabelButtonSelectImage3.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        LabelButtonSelectImage3.setText("Select Image");

        javax.swing.GroupLayout ButtonSelectImage3Layout = new javax.swing.GroupLayout(ButtonSelectImage3);
        ButtonSelectImage3.setLayout(ButtonSelectImage3Layout);
        ButtonSelectImage3Layout.setHorizontalGroup(
            ButtonSelectImage3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(LabelButtonSelectImage3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        ButtonSelectImage3Layout.setVerticalGroup(
            ButtonSelectImage3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(LabelButtonSelectImage3, javax.swing.GroupLayout.DEFAULT_SIZE, 31, Short.MAX_VALUE)
        );

        ListImages.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jScrollPane2.setViewportView(ListImages);

        javax.swing.GroupLayout BasicInformationPanel3Layout = new javax.swing.GroupLayout(BasicInformationPanel3);
        BasicInformationPanel3.setLayout(BasicInformationPanel3Layout);
        BasicInformationPanel3Layout.setHorizontalGroup(
            BasicInformationPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(BasicInformationPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(BasicInformationPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabel33)
                    .addComponent(jLabel30)
                    .addComponent(jLabel29))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(BasicInformationPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(BasicInformationPanel3Layout.createSequentialGroup()
                        .addGroup(BasicInformationPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(TextName3, javax.swing.GroupLayout.DEFAULT_SIZE, 215, Short.MAX_VALUE)
                            .addComponent(TextColor3))
                        .addGap(18, 18, 18)
                        .addGroup(BasicInformationPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, BasicInformationPanel3Layout.createSequentialGroup()
                                .addComponent(jLabel31)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(SpinnerAge3, javax.swing.GroupLayout.PREFERRED_SIZE, 215, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(BasicInformationPanel3Layout.createSequentialGroup()
                                .addComponent(jLabel32)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(TextChip3, javax.swing.GroupLayout.DEFAULT_SIZE, 215, Short.MAX_VALUE))))
                    .addComponent(jScrollPane7))
                .addGap(18, 18, 18)
                .addGroup(BasicInformationPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(ButtonSelectImage3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(ImagePreview3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 0, Short.MAX_VALUE))
                .addContainerGap())
        );
        BasicInformationPanel3Layout.setVerticalGroup(
            BasicInformationPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(BasicInformationPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(BasicInformationPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(BasicInformationPanel3Layout.createSequentialGroup()
                        .addGroup(BasicInformationPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel29)
                            .addComponent(TextName3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel31)
                            .addComponent(SpinnerAge3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(BasicInformationPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel30)
                            .addComponent(TextColor3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel32)
                            .addComponent(TextChip3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(BasicInformationPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(BasicInformationPanel3Layout.createSequentialGroup()
                                .addComponent(jLabel33)
                                .addGap(0, 0, Short.MAX_VALUE))
                            .addComponent(jScrollPane7)))
                    .addGroup(BasicInformationPanel3Layout.createSequentialGroup()
                        .addComponent(ImagePreview3, javax.swing.GroupLayout.PREFERRED_SIZE, 200, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(ButtonSelectImage3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 55, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(0, 0, Short.MAX_VALUE)))
                .addContainerGap())
        );

        PetDetailsPanel.setBorder(javax.swing.BorderFactory.createTitledBorder(null, "Pet Details", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Segoe UI", 1, 14), new java.awt.Color(142, 142, 142))); // NOI18N

        jLabel6.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jLabel6.setLabelFor(TextName3);
        jLabel6.setText("Species:");

        ComboType.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N

        ComboSpaceRequired.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        ComboSpaceRequired.addActionListener(this::ComboSpaceRequiredActionPerformed);

        jLabel7.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jLabel7.setLabelFor(TextName3);
        jLabel7.setText("Space required:");

        ComboBreed.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        ComboBreed.addActionListener(this::ComboBreedActionPerformed);

        jLabel8.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jLabel8.setLabelFor(TextName3);
        jLabel8.setText("Breed:");

        ComboEnergy.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        ComboEnergy.addActionListener(this::ComboEnergyActionPerformed);

        jLabel9.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jLabel9.setLabelFor(TextName3);
        jLabel9.setText("Energy:");

        ComboTraining.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        ComboTraining.addActionListener(this::ComboTrainingActionPerformed);

        jLabel10.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jLabel10.setLabelFor(TextName3);
        jLabel10.setText("Ease of training:");

        ComboSize.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        ComboSize.addActionListener(this::ComboSizeActionPerformed);

        jLabel11.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jLabel11.setLabelFor(TextName3);
        jLabel11.setText("Size:");

        javax.swing.GroupLayout PetDetailsPanelLayout = new javax.swing.GroupLayout(PetDetailsPanel);
        PetDetailsPanel.setLayout(PetDetailsPanelLayout);
        PetDetailsPanelLayout.setHorizontalGroup(
            PetDetailsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(PetDetailsPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(PetDetailsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabel10)
                    .addComponent(jLabel7)
                    .addComponent(jLabel6))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(PetDetailsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(ComboSpaceRequired, 0, 305, Short.MAX_VALUE)
                    .addComponent(ComboType, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(ComboTraining, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(18, 18, 18)
                .addGroup(PetDetailsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, PetDetailsPanelLayout.createSequentialGroup()
                        .addComponent(jLabel11)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(ComboSize, javax.swing.GroupLayout.PREFERRED_SIZE, 304, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, PetDetailsPanelLayout.createSequentialGroup()
                        .addGroup(PetDetailsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jLabel9)
                            .addComponent(jLabel8))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addGroup(PetDetailsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(ComboBreed, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(ComboEnergy, javax.swing.GroupLayout.PREFERRED_SIZE, 304, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        PetDetailsPanelLayout.setVerticalGroup(
            PetDetailsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(PetDetailsPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(PetDetailsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel6)
                    .addComponent(ComboType, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel8)
                    .addComponent(ComboBreed, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(PetDetailsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel7)
                    .addComponent(ComboSpaceRequired, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel9)
                    .addComponent(ComboEnergy, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(PetDetailsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(PetDetailsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel11)
                        .addComponent(ComboSize, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(PetDetailsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jLabel10)
                        .addComponent(ComboTraining, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        LocationPanel.setBorder(javax.swing.BorderFactory.createTitledBorder(null, "Location", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Segoe UI", 1, 14), new java.awt.Color(142, 142, 142))); // NOI18N

        jLabel12.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jLabel12.setLabelFor(TextName3);
        jLabel12.setText("Country:");

        ComboCountry.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N

        ComboCanton.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        ComboCanton.addActionListener(this::ComboCantonActionPerformed);

        jLabel13.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jLabel13.setLabelFor(TextName3);
        jLabel13.setText("Canton:");

        ComboProvince.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        ComboProvince.addActionListener(this::ComboProvinceActionPerformed);

        jLabel14.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jLabel14.setLabelFor(TextName3);
        jLabel14.setText("Province:");

        ComboDistrict.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        ComboDistrict.addActionListener(this::ComboDistrictActionPerformed);

        LabelDistrict.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        LabelDistrict.setLabelFor(TextName3);
        LabelDistrict.setText("District:");

        javax.swing.GroupLayout LocationPanelLayout = new javax.swing.GroupLayout(LocationPanel);
        LocationPanel.setLayout(LocationPanelLayout);
        LocationPanelLayout.setHorizontalGroup(
            LocationPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(LocationPanelLayout.createSequentialGroup()
                .addGap(10, 10, 10)
                .addGroup(LocationPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabel13)
                    .addComponent(jLabel12))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(LocationPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(ComboCanton, 0, 322, Short.MAX_VALUE)
                    .addComponent(ComboCountry, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(18, 18, 18)
                .addGroup(LocationPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(LocationPanelLayout.createSequentialGroup()
                        .addComponent(jLabel14)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(ComboProvince, javax.swing.GroupLayout.PREFERRED_SIZE, 322, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, LocationPanelLayout.createSequentialGroup()
                        .addComponent(LabelDistrict)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(ComboDistrict, javax.swing.GroupLayout.PREFERRED_SIZE, 321, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        LocationPanelLayout.setVerticalGroup(
            LocationPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(LocationPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(LocationPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel12)
                    .addComponent(ComboCountry, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel14)
                    .addComponent(ComboProvince, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(LocationPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel13)
                    .addComponent(ComboCanton, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(LabelDistrict)
                    .addComponent(ComboDistrict, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        VeterinarianPanel.setBorder(javax.swing.BorderFactory.createTitledBorder(null, "Veterinarian", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Segoe UI", 1, 14), new java.awt.Color(142, 142, 142))); // NOI18N

        jLabel15.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jLabel15.setLabelFor(TextName3);
        jLabel15.setText("Select your pet's veterinarian:");

        TextVeterinarian.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N

        ListVeterinarian.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N
        ListVeterinarian.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jScrollPane3.setViewportView(ListVeterinarian);

        javax.swing.GroupLayout VeterinarianPanelLayout = new javax.swing.GroupLayout(VeterinarianPanel);
        VeterinarianPanel.setLayout(VeterinarianPanelLayout);
        VeterinarianPanelLayout.setHorizontalGroup(
            VeterinarianPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(VeterinarianPanelLayout.createSequentialGroup()
                .addGroup(VeterinarianPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(VeterinarianPanelLayout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(jLabel15)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(TextVeterinarian))
                    .addComponent(jScrollPane3))
                .addContainerGap())
        );
        VeterinarianPanelLayout.setVerticalGroup(
            VeterinarianPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(VeterinarianPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(VeterinarianPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel15)
                    .addComponent(TextVeterinarian, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        PetHealthPanel.setBorder(javax.swing.BorderFactory.createTitledBorder(null, "Pet health", javax.swing.border.TitledBorder.DEFAULT_JUSTIFICATION, javax.swing.border.TitledBorder.DEFAULT_POSITION, new java.awt.Font("Segoe UI", 1, 14), new java.awt.Color(142, 142, 142))); // NOI18N

        jLabel16.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jLabel16.setLabelFor(TextName3);
        jLabel16.setText("Your pet suffers from some illness:");

        ComboIllness.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N

        ListPetMedicine.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jScrollPane4.setViewportView(ListPetMedicine);

        ButtonAddIllness.setBackground(new java.awt.Color(0, 102, 102));

        LabelButtonAddIllness.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        LabelButtonAddIllness.setForeground(new java.awt.Color(255, 255, 255));
        LabelButtonAddIllness.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        LabelButtonAddIllness.setText("Add");

        javax.swing.GroupLayout ButtonAddIllnessLayout = new javax.swing.GroupLayout(ButtonAddIllness);
        ButtonAddIllness.setLayout(ButtonAddIllnessLayout);
        ButtonAddIllnessLayout.setHorizontalGroup(
            ButtonAddIllnessLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(LabelButtonAddIllness, javax.swing.GroupLayout.DEFAULT_SIZE, 251, Short.MAX_VALUE)
        );
        ButtonAddIllnessLayout.setVerticalGroup(
            ButtonAddIllnessLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(ButtonAddIllnessLayout.createSequentialGroup()
                .addComponent(LabelButtonAddIllness, javax.swing.GroupLayout.DEFAULT_SIZE, 26, Short.MAX_VALUE)
                .addGap(0, 0, Short.MAX_VALUE))
        );

        jLabel17.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jLabel17.setLabelFor(TextName3);
        jLabel17.setText("Your pet needs some medicine:");

        ComboMedicine.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N

        ButtonAddMedicine.setBackground(new java.awt.Color(0, 102, 102));

        LabelButtonAddMedicine.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        LabelButtonAddMedicine.setForeground(new java.awt.Color(255, 255, 255));
        LabelButtonAddMedicine.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        LabelButtonAddMedicine.setText("Add");

        javax.swing.GroupLayout ButtonAddMedicineLayout = new javax.swing.GroupLayout(ButtonAddMedicine);
        ButtonAddMedicine.setLayout(ButtonAddMedicineLayout);
        ButtonAddMedicineLayout.setHorizontalGroup(
            ButtonAddMedicineLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(LabelButtonAddMedicine, javax.swing.GroupLayout.DEFAULT_SIZE, 257, Short.MAX_VALUE)
        );
        ButtonAddMedicineLayout.setVerticalGroup(
            ButtonAddMedicineLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(ButtonAddMedicineLayout.createSequentialGroup()
                .addComponent(LabelButtonAddMedicine, javax.swing.GroupLayout.DEFAULT_SIZE, 26, Short.MAX_VALUE)
                .addGap(0, 0, Short.MAX_VALUE))
        );

        ListPetIllness.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jScrollPane5.setViewportView(ListPetIllness);

        jLabel18.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        jLabel18.setLabelFor(TextName3);
        jLabel18.setText("Your pet needs some treatment:");

        ComboTreatment.setFont(new java.awt.Font("Segoe UI", 0, 14)); // NOI18N

        ButtonAddTreatment.setBackground(new java.awt.Color(0, 102, 102));

        LabelButtonAddTreatment.setFont(new java.awt.Font("Segoe UI", 1, 14)); // NOI18N
        LabelButtonAddTreatment.setForeground(new java.awt.Color(255, 255, 255));
        LabelButtonAddTreatment.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        LabelButtonAddTreatment.setText("Add");

        javax.swing.GroupLayout ButtonAddTreatmentLayout = new javax.swing.GroupLayout(ButtonAddTreatment);
        ButtonAddTreatment.setLayout(ButtonAddTreatmentLayout);
        ButtonAddTreatmentLayout.setHorizontalGroup(
            ButtonAddTreatmentLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(LabelButtonAddTreatment, javax.swing.GroupLayout.DEFAULT_SIZE, 257, Short.MAX_VALUE)
        );
        ButtonAddTreatmentLayout.setVerticalGroup(
            ButtonAddTreatmentLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(ButtonAddTreatmentLayout.createSequentialGroup()
                .addComponent(LabelButtonAddTreatment, javax.swing.GroupLayout.DEFAULT_SIZE, 26, Short.MAX_VALUE)
                .addGap(0, 0, Short.MAX_VALUE))
        );

        ListPetTreatment.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jScrollPane6.setViewportView(ListPetTreatment);

        javax.swing.GroupLayout PetHealthPanelLayout = new javax.swing.GroupLayout(PetHealthPanel);
        PetHealthPanel.setLayout(PetHealthPanelLayout);
        PetHealthPanelLayout.setHorizontalGroup(
            PetHealthPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(PetHealthPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(PetHealthPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane4)
                    .addGroup(PetHealthPanelLayout.createSequentialGroup()
                        .addGroup(PetHealthPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(PetHealthPanelLayout.createSequentialGroup()
                                .addComponent(jLabel16)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                                .addComponent(ComboIllness, javax.swing.GroupLayout.PREFERRED_SIZE, 305, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(PetHealthPanelLayout.createSequentialGroup()
                                .addComponent(jLabel17)
                                .addGap(37, 37, 37)
                                .addComponent(ComboMedicine, javax.swing.GroupLayout.PREFERRED_SIZE, 305, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(ButtonAddMedicine, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jScrollPane5)
                    .addGroup(PetHealthPanelLayout.createSequentialGroup()
                        .addComponent(jLabel18)
                        .addGap(31, 31, 31)
                        .addComponent(ComboTreatment, javax.swing.GroupLayout.PREFERRED_SIZE, 305, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(ButtonAddTreatment, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jScrollPane6, javax.swing.GroupLayout.Alignment.TRAILING))
                .addContainerGap())
            .addGroup(PetHealthPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, PetHealthPanelLayout.createSequentialGroup()
                    .addGap(571, 571, 571)
                    .addComponent(ButtonAddIllness, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addContainerGap()))
        );
        PetHealthPanelLayout.setVerticalGroup(
            PetHealthPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(PetHealthPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(PetHealthPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel16)
                    .addComponent(ComboIllness, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(18, 18, 18)
                .addComponent(jScrollPane5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addGroup(PetHealthPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(ButtonAddMedicine, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(PetHealthPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(ComboMedicine, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel17)))
                .addGap(18, 18, 18)
                .addComponent(jScrollPane4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addGroup(PetHealthPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jLabel18)
                    .addGroup(PetHealthPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                        .addComponent(ButtonAddTreatment, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(ComboTreatment, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(18, 18, 18)
                .addComponent(jScrollPane6, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addGroup(PetHealthPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(PetHealthPanelLayout.createSequentialGroup()
                    .addContainerGap()
                    .addComponent(ButtonAddIllness, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addContainerGap(437, Short.MAX_VALUE)))
        );

        ButtonSubmitPet.setBackground(new java.awt.Color(255, 153, 51));

        jLabel34.setFont(new java.awt.Font("Segoe UI", 1, 18)); // NOI18N
        jLabel34.setForeground(new java.awt.Color(255, 255, 255));
        jLabel34.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel34.setText("Save Pet");

        javax.swing.GroupLayout ButtonSubmitPetLayout = new javax.swing.GroupLayout(ButtonSubmitPet);
        ButtonSubmitPet.setLayout(ButtonSubmitPetLayout);
        ButtonSubmitPetLayout.setHorizontalGroup(
            ButtonSubmitPetLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jLabel34, javax.swing.GroupLayout.DEFAULT_SIZE, 260, Short.MAX_VALUE)
        );
        ButtonSubmitPetLayout.setVerticalGroup(
            ButtonSubmitPetLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jLabel34, javax.swing.GroupLayout.DEFAULT_SIZE, 47, Short.MAX_VALUE)
        );

        ButtonCancel.setBackground(new java.awt.Color(120, 120, 120));

        jLabel35.setFont(new java.awt.Font("Segoe UI", 1, 18)); // NOI18N
        jLabel35.setForeground(new java.awt.Color(255, 255, 255));
        jLabel35.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel35.setText("Cancel");

        javax.swing.GroupLayout ButtonCancelLayout = new javax.swing.GroupLayout(ButtonCancel);
        ButtonCancel.setLayout(ButtonCancelLayout);
        ButtonCancelLayout.setHorizontalGroup(
            ButtonCancelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jLabel35, javax.swing.GroupLayout.DEFAULT_SIZE, 260, Short.MAX_VALUE)
        );
        ButtonCancelLayout.setVerticalGroup(
            ButtonCancelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jLabel35, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, 47, Short.MAX_VALUE)
        );

        javax.swing.GroupLayout FinalPanelLayout = new javax.swing.GroupLayout(FinalPanel);
        FinalPanel.setLayout(FinalPanelLayout);
        FinalPanelLayout.setHorizontalGroup(
            FinalPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, FinalPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(ButtonCancel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(ButtonSubmitPet, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );
        FinalPanelLayout.setVerticalGroup(
            FinalPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(FinalPanelLayout.createSequentialGroup()
                .addGap(21, 21, 21)
                .addGroup(FinalPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(ButtonCancel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(ButtonSubmitPet, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(19, Short.MAX_VALUE))
        );

        javax.swing.GroupLayout FormPanelInsertPetLayout = new javax.swing.GroupLayout(FormPanelInsertPet);
        FormPanelInsertPet.setLayout(FormPanelInsertPetLayout);
        FormPanelInsertPetLayout.setHorizontalGroup(
            FormPanelInsertPetLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(FormPanelInsertPetLayout.createSequentialGroup()
                .addGap(18, 18, 18)
                .addGroup(FormPanelInsertPetLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(BasicInformationPanel3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(PetDetailsPanel, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(LocationPanel, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(VeterinarianPanel, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(PetHealthPanel, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(FinalPanel, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addGap(50, 50, 50))
        );
        FormPanelInsertPetLayout.setVerticalGroup(
            FormPanelInsertPetLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(FormPanelInsertPetLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(BasicInformationPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(PetDetailsPanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(LocationPanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(VeterinarianPanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(PetHealthPanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(FinalPanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );

        ScrollPanelFirst.setViewportView(FormPanelInsertPet);

        PanelBackGround.add(ScrollPanelFirst, new org.netbeans.lib.awtextra.AbsoluteConstraints(-1, 60, -1, -1));

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(PanelBackGround, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(PanelBackGround, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void ComboDistrictActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_ComboDistrictActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_ComboDistrictActionPerformed

    private void ComboProvinceActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_ComboProvinceActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_ComboProvinceActionPerformed

    private void ComboCantonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_ComboCantonActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_ComboCantonActionPerformed

    private void ComboSizeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_ComboSizeActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_ComboSizeActionPerformed

    private void ComboTrainingActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_ComboTrainingActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_ComboTrainingActionPerformed

    private void ComboEnergyActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_ComboEnergyActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_ComboEnergyActionPerformed

    private void ComboBreedActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_ComboBreedActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_ComboBreedActionPerformed

    private void ComboSpaceRequiredActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_ComboSpaceRequiredActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_ComboSpaceRequiredActionPerformed

    private void TextChipActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_TextChipActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_TextChipActionPerformed

    private void TextColorActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_TextColorActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_TextColorActionPerformed

    private void TextNameActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_TextNameActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_TextNameActionPerformed

    
    
    
    
    
    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ReflectiveOperationException | javax.swing.UnsupportedLookAndFeelException ex) {
            logger.log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(() -> new InsertPetForm().setVisible(true));
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JPanel BasicInformationPanel3;
    private javax.swing.JPanel ButtonAddIllness;
    private javax.swing.JPanel ButtonAddMedicine;
    private javax.swing.JPanel ButtonAddTreatment;
    private javax.swing.JPanel ButtonCancel;
    private javax.swing.JPanel ButtonSelectImage3;
    private javax.swing.JPanel ButtonSubmitPet;
    private javax.swing.JComboBox<DbObject> ComboBreed;
    private javax.swing.JComboBox<DbObject> ComboCanton;
    private javax.swing.JComboBox<DbObject> ComboCountry;
    private javax.swing.JComboBox<DbObject> ComboDistrict;
    private javax.swing.JComboBox<DbObject> ComboEnergy;
    private javax.swing.JComboBox<DbObject> ComboIllness;
    private javax.swing.JComboBox<DbObject> ComboMedicine;
    private javax.swing.JComboBox<DbObject> ComboProvince;
    private javax.swing.JComboBox<DbObject> ComboSize;
    private javax.swing.JComboBox<DbObject> ComboSpaceRequired;
    private javax.swing.JComboBox<DbObject> ComboTraining;
    private javax.swing.JComboBox<DbObject> ComboTreatment;
    private javax.swing.JComboBox<DbObject> ComboType;
    private javax.swing.JPanel FinalPanel;
    private javax.swing.JPanel FormPanelInsertPet;
    private javax.swing.JLabel ImagePreview3;
    private javax.swing.JLabel LabelButtonAddIllness;
    private javax.swing.JLabel LabelButtonAddMedicine;
    private javax.swing.JLabel LabelButtonAddTreatment;
    private javax.swing.JLabel LabelButtonSelectImage3;
    private javax.swing.JLabel LabelDistrict;
    private javax.swing.JLabel LableTitle;
    private javax.swing.JList<DbObject> ListImages;
    private javax.swing.JList<DbObject> ListPetIllness;
    private javax.swing.JList<DbObject> ListPetMedicine;
    private javax.swing.JList<DbObject> ListPetTreatment;
    private javax.swing.JList<DbObject> ListVeterinarian;
    private javax.swing.JPanel LocationPanel;
    private javax.swing.JPanel PanelBackGround;
    private javax.swing.JPanel PetDetailsPanel;
    private javax.swing.JPanel PetHealthPanel;
    private javax.swing.JScrollPane ScrollPanelFirst;
    private javax.swing.JSpinner SpinnerAge3;
    private javax.swing.JTextField TextChip3;
    private javax.swing.JTextField TextColor3;
    private javax.swing.JTextArea TextDescription3;
    private javax.swing.JTextField TextName3;
    private javax.swing.JTextField TextVeterinarian;
    private javax.swing.JPanel VeterinarianPanel;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel13;
    private javax.swing.JLabel jLabel14;
    private javax.swing.JLabel jLabel15;
    private javax.swing.JLabel jLabel16;
    private javax.swing.JLabel jLabel17;
    private javax.swing.JLabel jLabel18;
    private javax.swing.JLabel jLabel29;
    private javax.swing.JLabel jLabel30;
    private javax.swing.JLabel jLabel31;
    private javax.swing.JLabel jLabel32;
    private javax.swing.JLabel jLabel33;
    private javax.swing.JLabel jLabel34;
    private javax.swing.JLabel jLabel35;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JScrollPane jScrollPane4;
    private javax.swing.JScrollPane jScrollPane5;
    private javax.swing.JScrollPane jScrollPane6;
    private javax.swing.JScrollPane jScrollPane7;
    // End of variables declaration//GEN-END:variables
}
